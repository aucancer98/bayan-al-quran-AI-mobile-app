#!/usr/bin/env python3
"""
Training script for custom Islamic AI model
This script trains a model on Quran, Hadith, and Islamic texts
"""

import json
import os
import re
import unicodedata
from pathlib import Path
from typing import List, Dict, Tuple
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
from transformers import (
    AutoTokenizer, 
    AutoModelForCausalLM, 
    TrainingArguments, 
    Trainer,
    DataCollatorForLanguageModeling
)
import numpy as np
from sklearn.model_selection import train_test_split

class IslamicDataset(Dataset):
    """Dataset for Islamic texts"""
    
    def __init__(self, texts: List[str], tokenizer, max_length: int = 512):
        self.texts = texts
        self.tokenizer = tokenizer
        self.max_length = max_length
    
    def __len__(self):
        return len(self.texts)
    
    def __getitem__(self, idx):
        text = self.texts[idx]
        
        # Tokenize text
        encoding = self.tokenizer(
            text,
            truncation=True,
            padding='max_length',
            max_length=self.max_length,
            return_tensors='pt'
        )
        
        return {
            'input_ids': encoding['input_ids'].flatten(),
            'attention_mask': encoding['attention_mask'].flatten(),
            'labels': encoding['input_ids'].flatten()
        }

class IslamicDataProcessor:
    """Process Islamic texts for training"""
    
    def __init__(self):
        self.arabic_pattern = re.compile(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]+')
    
    def clean_arabic_text(self, text: str) -> str:
        """Clean and normalize Arabic text"""
        # Normalize Unicode
        text = unicodedata.normalize('NFKD', text)
        
        # Remove extra whitespace
        text = re.sub(r'\s+', ' ', text).strip()
        
        # Remove non-Arabic characters (optional)
        # text = ' '.join(self.arabic_pattern.findall(text))
        
        return text
    
    def load_quran_data(self, quran_path: str) -> List[str]:
        """Load Quran data"""
        with open(quran_path, 'r', encoding='utf-8') as f:
            quran = json.load(f)
        
        texts = []
        for surah in quran['surahs']:
            for ayah in surah['ayahs']:
                # Create training text
                text = f"<ayah>{ayah['text']}</ayah>"
                if 'translation' in ayah:
                    text += f" <translation>{ayah['translation']}</translation>"
                
                texts.append(self.clean_arabic_text(text))
        
        return texts
    
    def load_hadith_data(self, hadith_path: str) -> List[str]:
        """Load Hadith data"""
        with open(hadith_path, 'r', encoding='utf-8') as f:
            hadiths = json.load(f)
        
        texts = []
        for hadith in hadiths:
            # Create training text
            text = f"<hadith>{hadith['text']}</hadith>"
            if 'arabic' in hadith:
                text = f"<hadith>{hadith['arabic']}</hadith>"
            if 'source' in hadith:
                text += f" <source>{hadith['source']}</source>"
            
            texts.append(self.clean_arabic_text(text))
        
        return texts
    
    def load_tafsir_data(self, tafsir_path: str) -> List[str]:
        """Load Tafsir data"""
        with open(tafsir_path, 'r', encoding='utf-8') as f:
            tafsir = json.load(f)
        
        texts = []
        for entry in tafsir:
            text = f"<tafsir>{entry['text']}</tafsir>"
            if 'verse' in entry:
                text = f"<verse>{entry['verse']}</verse> {text}"
            
            texts.append(self.clean_arabic_text(text))
        
        return texts
    
    def create_training_pairs(self, texts: List[str]) -> List[str]:
        """Create training pairs for different tasks"""
        training_texts = []
        
        for text in texts:
            # Add the original text
            training_texts.append(text)
            
            # Create question-answer pairs
            if '<ayah>' in text:
                ayah_text = re.search(r'<ayah>(.*?)</ayah>', text)
                if ayah_text:
                    question = f"What does this ayah mean: {ayah_text.group(1)[:50]}..."
                    training_texts.append(f"<question>{question}</question> {text}")
            
            if '<hadith>' in text:
                hadith_text = re.search(r'<hadith>(.*?)</hadith>', text)
                if hadith_text:
                    question = f"Explain this hadith: {hadith_text.group(1)[:50]}..."
                    training_texts.append(f"<question>{question}</question> {text}")
        
        return training_texts

class IslamicModelTrainer:
    """Trainer for Islamic AI model"""
    
    def __init__(self, model_name: str = "aubmindlab/bert-base-arabertv2"):
        self.model_name = model_name
        self.tokenizer = AutoTokenizer.from_pretrained(model_name)
        self.model = AutoModelForCausalLM.from_pretrained(model_name)
        
        # Add special tokens for Islamic content
        special_tokens = [
            '<ayah>', '</ayah>',
            '<hadith>', '</hadith>',
            '<tafsir>', '</tafsir>',
            '<question>', '</question>',
            '<translation>', '</translation>',
            '<source>', '</source>',
            '<verse>', '</verse>'
        ]
        
        self.tokenizer.add_tokens(special_tokens)
        self.model.resize_token_embeddings(len(self.tokenizer))
        
        # Set pad token
        if self.tokenizer.pad_token is None:
            self.tokenizer.pad_token = self.tokenizer.eos_token
    
    def prepare_data(self, data_paths: Dict[str, str]) -> Tuple[List[str], List[str]]:
        """Prepare training data"""
        processor = IslamicDataProcessor()
        all_texts = []
        
        # Load data from different sources
        if 'quran' in data_paths:
            quran_texts = processor.load_quran_data(data_paths['quran'])
            all_texts.extend(quran_texts)
            print(f"Loaded {len(quran_texts)} Quran texts")
        
        if 'hadith' in data_paths:
            hadith_texts = processor.load_hadith_data(data_paths['hadith'])
            all_texts.extend(hadith_texts)
            print(f"Loaded {len(hadith_texts)} Hadith texts")
        
        if 'tafsir' in data_paths:
            tafsir_texts = processor.load_tafsir_data(data_paths['tafsir'])
            all_texts.extend(tafsir_texts)
            print(f"Loaded {len(tafsir_texts)} Tafsir texts")
        
        # Create training pairs
        training_texts = processor.create_training_pairs(all_texts)
        print(f"Created {len(training_texts)} training texts")
        
        # Split into train and validation
        train_texts, val_texts = train_test_split(
            training_texts, 
            test_size=0.1, 
            random_state=42
        )
        
        return train_texts, val_texts
    
    def train(self, train_texts: List[str], val_texts: List[str], output_dir: str = "./islamic_model"):
        """Train the model"""
        # Create datasets
        train_dataset = IslamicDataset(train_texts, self.tokenizer)
        val_dataset = IslamicDataset(val_texts, self.tokenizer)
        
        # Data collator
        data_collator = DataCollatorForLanguageModeling(
            tokenizer=self.tokenizer,
            mlm=False,  # We're doing causal LM, not masked LM
        )
        
        # Training arguments
        training_args = TrainingArguments(
            output_dir=output_dir,
            num_train_epochs=3,
            per_device_train_batch_size=4,
            per_device_eval_batch_size=4,
            warmup_steps=500,
            weight_decay=0.01,
            logging_dir=f'{output_dir}/logs',
            logging_steps=100,
            save_steps=1000,
            evaluation_strategy="steps",
            eval_steps=1000,
            save_total_limit=2,
            load_best_model_at_end=True,
            metric_for_best_model="eval_loss",
            greater_is_better=False,
        )
        
        # Create trainer
        trainer = Trainer(
            model=self.model,
            args=training_args,
            train_dataset=train_dataset,
            eval_dataset=val_dataset,
            data_collator=data_collator,
            tokenizer=self.tokenizer,
        )
        
        # Train
        print("Starting training...")
        trainer.train()
        
        # Save model
        trainer.save_model()
        self.tokenizer.save_pretrained(output_dir)
        
        print(f"Model saved to {output_dir}")
        return trainer

def main():
    """Main training function"""
    # Data paths (adjust these to your actual data paths)
    data_paths = {
        'quran': 'assets/data/quran/complete_quran.json',
        'hadith': 'assets/data/hadith/sahih_bukhari.json',
        # Add more data sources as needed
    }
    
    # Check if data files exist
    for source, path in data_paths.items():
        if not os.path.exists(path):
            print(f"Warning: {source} data file not found at {path}")
    
    # Initialize trainer
    trainer = IslamicModelTrainer()
    
    # Prepare data
    print("Preparing data...")
    train_texts, val_texts = trainer.prepare_data(data_paths)
    
    if not train_texts:
        print("No training data found. Please check your data paths.")
        return
    
    # Train model
    print("Training model...")
    trainer.train(train_texts, val_texts)
    
    print("Training completed successfully!")

if __name__ == "__main__":
    main()
