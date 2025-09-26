#!/usr/bin/env python3
"""
Simplified training script for Islamic AI model
Uses a smaller, more manageable model for initial training
"""

import json
import os
import torch
from torch.utils.data import Dataset, DataLoader
from transformers import (
    AutoTokenizer, 
    AutoModelForCausalLM, 
    TrainingArguments, 
    Trainer,
    DataCollatorForLanguageModeling
)
from sklearn.model_selection import train_test_split
import numpy as np
from tqdm import tqdm

class IslamicDataset(Dataset):
    """Dataset for Islamic texts"""
    
    def __init__(self, texts, tokenizer, max_length=256):
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

class SimpleIslamicTrainer:
    """Simplified trainer for Islamic AI model"""
    
    def __init__(self, model_name="distilgpt2"):
        print(f"🤖 Initializing model: {model_name}")
        
        # Use a smaller, faster model for initial training
        self.model_name = model_name
        self.tokenizer = AutoTokenizer.from_pretrained(model_name)
        self.model = AutoModelForCausalLM.from_pretrained(model_name)
        
        # Add special tokens for Islamic content
        special_tokens = [
            '<ayah>', '</ayah>',
            '<hadith>', '</hadith>',
            '<translation>', '</translation>',
            '<question>', '</question>',
            '<word_analysis>', '</word_analysis>',
            '<context>', '</context>',
            '<narrator>', '</narrator>',
            '<grade>', '</grade>',
            '<reference>', '</reference>'
        ]
        
        self.tokenizer.add_tokens(special_tokens)
        self.model.resize_token_embeddings(len(self.tokenizer))
        
        # Set pad token
        if self.tokenizer.pad_token is None:
            self.tokenizer.pad_token = self.tokenizer.eos_token
        
        print(f"✅ Model initialized with {len(self.tokenizer)} tokens")
    
    def load_training_data(self, data_path):
        """Load training data"""
        print(f"📚 Loading training data from {data_path}")
        
        with open(data_path, 'r', encoding='utf-8') as f:
            texts = json.load(f)
        
        print(f"✅ Loaded {len(texts)} training texts")
        return texts
    
    def prepare_datasets(self, texts, test_size=0.1):
        """Prepare train and validation datasets"""
        print("🔄 Preparing datasets...")
        
        # Split data
        train_texts, val_texts = train_test_split(
            texts, 
            test_size=test_size, 
            random_state=42
        )
        
        # Create datasets
        train_dataset = IslamicDataset(train_texts, self.tokenizer)
        val_dataset = IslamicDataset(val_texts, self.tokenizer)
        
        print(f"✅ Training samples: {len(train_dataset)}")
        print(f"✅ Validation samples: {len(val_dataset)}")
        
        return train_dataset, val_dataset
    
    def train(self, train_dataset, val_dataset, output_dir="./islamic_model"):
        """Train the model"""
        print("🚀 Starting training...")
        
        # Data collator
        data_collator = DataCollatorForLanguageModeling(
            tokenizer=self.tokenizer,
            mlm=False,  # We're doing causal LM, not masked LM
        )
        
        # Training arguments - optimized for smaller dataset
        training_args = TrainingArguments(
            output_dir=output_dir,
            num_train_epochs=3,
            per_device_train_batch_size=2,  # Small batch size for memory
            per_device_eval_batch_size=2,
            warmup_steps=50,
            weight_decay=0.01,
            logging_dir=f'{output_dir}/logs',
            logging_steps=10,
            save_steps=100,
            evaluation_strategy="steps",
            eval_steps=100,
            save_total_limit=2,
            load_best_model_at_end=True,
            metric_for_best_model="eval_loss",
            greater_is_better=False,
            report_to=None,  # Disable wandb
            remove_unused_columns=False,
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
        print("🔥 Training started...")
        trainer.train()
        
        # Save model
        print("💾 Saving model...")
        trainer.save_model()
        self.tokenizer.save_pretrained(output_dir)
        
        print(f"✅ Model saved to {output_dir}")
        return trainer
    
    def test_model(self, test_texts, num_samples=5):
        """Test the trained model"""
        print("🧪 Testing model...")
        
        for i, text in enumerate(test_texts[:num_samples]):
            print(f"\n--- Test {i+1} ---")
            print(f"Input: {text[:100]}...")
            
            # Generate response
            inputs = self.tokenizer(text, return_tensors="pt", truncation=True, max_length=128)
            
            with torch.no_grad():
                outputs = self.model.generate(
                    inputs.input_ids,
                    max_length=200,
                    num_return_sequences=1,
                    temperature=0.7,
                    do_sample=True,
                    pad_token_id=self.tokenizer.eos_token_id
                )
            
            generated_text = self.tokenizer.decode(outputs[0], skip_special_tokens=True)
            print(f"Generated: {generated_text}")

def main():
    """Main training function"""
    print("🕌 Starting Islamic AI Model Training")
    print("=" * 50)
    
    # Check if training data exists
    data_path = "training_data/islamic_training_data.json"
    if not os.path.exists(data_path):
        print(f"❌ Training data not found at {data_path}")
        print("Please run prepare_training_data.py first")
        return
    
    try:
        # Initialize trainer
        trainer = SimpleIslamicTrainer()
        
        # Load training data
        texts = trainer.load_training_data(data_path)
        
        # Prepare datasets
        train_dataset, val_dataset = trainer.prepare_datasets(texts)
        
        # Train model
        trainer.train(train_dataset, val_dataset)
        
        # Test model
        test_texts = [
            "<question>What does this ayah mean: بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ</question>",
            "<question>Explain this hadith: كَانَ أَوَّلُ مَا بُدِئَ بِهِ</question>",
            "<ayah>الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ</ayah>",
        ]
        trainer.test_model(test_texts)
        
        print("\n🎉 Training completed successfully!")
        print("📁 Model saved to: ./islamic_model")
        print("📊 Check logs in: ./islamic_model/logs")
        
    except Exception as e:
        print(f"❌ Training failed: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()