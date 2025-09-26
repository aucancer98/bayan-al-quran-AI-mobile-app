#!/usr/bin/env python3
"""
Data preparation script for Islamic AI model training
Processes Quran, Hadith, and Islamic texts for training
"""

import json
import os
import re
import unicodedata
from pathlib import Path
from typing import List, Dict, Tuple
import pandas as pd
from tqdm import tqdm

class IslamicDataProcessor:
    """Process Islamic texts for training"""
    
    def __init__(self):
        self.arabic_pattern = re.compile(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]+')
        self.training_texts = []
        
    def clean_arabic_text(self, text: str) -> str:
        """Clean and normalize Arabic text"""
        if not text:
            return ""
        
        # Normalize Unicode
        text = unicodedata.normalize('NFKD', text)
        
        # Remove extra whitespace
        text = re.sub(r'\s+', ' ', text).strip()
        
        return text
    
    def load_quran_data(self, quran_path: str) -> List[str]:
        """Load Quran data from your JSON format"""
        print("📖 Loading Quran data...")
        
        with open(quran_path, 'r', encoding='utf-8') as f:
            quran = json.load(f)
        
        texts = []
        total_ayahs = 0
        
        for surah in tqdm(quran['surahs'], desc="Processing surahs"):
            surah_name = surah['nameEnglish']
            surah_number = surah['number']
            
            for ayah in surah['ayahs']:
                ayah_number = ayah['ayahNumber']
                arabic_text = ayah['arabicText']
                
                # Clean Arabic text
                clean_arabic = self.clean_arabic_text(arabic_text)
                if not clean_arabic:
                    continue
                
                # Create training text with context
                text = f"<ayah>{clean_arabic}</ayah>"
                
                # Add translations if available
                if 'translations' in ayah and ayah['translations']:
                    for translation in ayah['translations']:
                        if 'text' in translation and translation['text']:
                            text += f" <translation>{translation['text']}</translation>"
                
                # Add word analysis if available
                if 'words' in ayah and ayah['words']:
                    word_analysis = []
                    for word in ayah['words']:
                        if 'arabic' in word and 'meaning' in word:
                            word_analysis.append(f"{word['arabic']}:{word['meaning']}")
                    
                    if word_analysis:
                        text += f" <word_analysis>{'|'.join(word_analysis)}</word_analysis>"
                
                # Add context
                text += f" <context>Surah {surah_number}:{ayah_number} - {surah_name}</context>"
                
                texts.append(text)
                total_ayahs += 1
        
        print(f"✅ Loaded {total_ayahs} ayahs from {len(quran['surahs'])} surahs")
        return texts
    
    def load_hadith_data(self, hadith_path: str) -> List[str]:
        """Load Hadith data from your JSON format"""
        print(f"📚 Loading Hadith data from {hadith_path}...")
        
        try:
            with open(hadith_path, 'r', encoding='utf-8') as f:
                hadith_data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"❌ JSON parsing error in {hadith_path}: {e}")
            print("Skipping this file...")
            return []
        
        texts = []
        collection_name = hadith_data['collection']
        
        for hadith in tqdm(hadith_data['hadiths'], desc=f"Processing {collection_name}"):
            # Get Arabic and English text
            arabic_text = hadith.get('textArabic', '')
            english_text = hadith.get('textEnglish', '')
            
            if not arabic_text and not english_text:
                continue
            
            # Clean texts
            clean_arabic = self.clean_arabic_text(arabic_text)
            clean_english = self.clean_arabic_text(english_text)
            
            # Create training text
            text = ""
            if clean_arabic:
                text += f"<hadith>{clean_arabic}</hadith>"
            if clean_english:
                text += f" <translation>{clean_english}</translation>"
            
            # Add metadata
            narrator = hadith.get('narrator', '')
            grade = hadith.get('grade', '')
            reference = hadith.get('reference', '')
            
            if narrator:
                text += f" <narrator>{narrator}</narrator>"
            if grade:
                text += f" <grade>{grade}</grade>"
            if reference:
                text += f" <reference>{reference}</reference>"
            
            # Add context
            text += f" <context>{collection_name}</context>"
            
            texts.append(text)
        
        print(f"✅ Loaded {len(texts)} hadiths from {collection_name}")
        return texts
    
    def load_tafsir_data(self, tafsir_path: str) -> List[str]:
        """Load Tafsir data from your JSON format"""
        print(f"📖 Loading Tafsir data from {tafsir_path}...")
        
        with open(tafsir_path, 'r', encoding='utf-8') as f:
            tafsir = json.load(f)
        
        texts = []
        surah_name = tafsir.get('surahName', 'Unknown')
        surah_number = tafsir.get('surahNumber', 0)
        
        for entry in tqdm(tafsir['tafsir'], desc=f"Processing {surah_name} Tafsir"):
            ayah_number = entry['ayahNumber']
            arabic_text = entry['arabicText']
            
            # Clean Arabic text
            clean_arabic = self.clean_arabic_text(arabic_text)
            if not clean_arabic:
                continue
            
            # Process each Tafsir source
            for source in entry.get('tafsirSources', []):
                author = source.get('author', 'Unknown')
                commentary = source.get('commentary', '')
                key_points = source.get('keyPoints', [])
                
                if not commentary:
                    continue
                
                # Create training text
                text = f"<ayah>{clean_arabic}</ayah>"
                text += f" <tafsir>{commentary}</tafsir>"
                text += f" <author>{author}</author>"
                
                # Add key points if available
                if key_points:
                    key_points_text = ' | '.join(key_points)
                    text += f" <key_points>{key_points_text}</key_points>"
                
                # Add context
                text += f" <context>Surah {surah_number}:{ayah_number} - {surah_name}</context>"
                
                texts.append(text)
        
        print(f"✅ Loaded {len(texts)} Tafsir entries from {surah_name}")
        return texts
    
    def create_training_pairs(self, texts: List[str]) -> List[str]:
        """Create training pairs for different tasks"""
        print("🔄 Creating training pairs...")
        
        training_texts = []
        
        for text in tqdm(texts, desc="Creating training pairs"):
            # Add the original text
            training_texts.append(text)
            
            # Create question-answer pairs
            if '<ayah>' in text:
                ayah_match = re.search(r'<ayah>(.*?)</ayah>', text)
                if ayah_match:
                    ayah_text = ayah_match.group(1)
                    if len(ayah_text) > 20:  # Only for longer ayahs
                        question = f"<question>What does this ayah mean: {ayah_text[:50]}...</question>"
                        training_texts.append(f"{question} {text}")
            
            if '<hadith>' in text:
                hadith_match = re.search(r'<hadith>(.*?)</hadith>', text)
                if hadith_match:
                    hadith_text = hadith_match.group(1)
                    if len(hadith_text) > 30:  # Only for longer hadiths
                        question = f"<question>Explain this hadith: {hadith_text[:50]}...</question>"
                        training_texts.append(f"{question} {text}")
            
            # Create word analysis pairs
            if '<word_analysis>' in text:
                word_match = re.search(r'<word_analysis>(.*?)</word_analysis>', text)
                if word_match:
                    word_analysis = word_match.group(1)
                    question = f"<question>Analyze the words in this text</question>"
                    training_texts.append(f"{question} {text}")
        
        print(f"✅ Created {len(training_texts)} training texts")
        return training_texts
    
    def save_training_data(self, texts: List[str], output_path: str):
        """Save training data to files"""
        print(f"💾 Saving training data to {output_path}")
        
        # Create output directory
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        # Save as JSON
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(texts, f, ensure_ascii=False, indent=2)
        
        # Save as text file for easy inspection
        text_path = output_path.replace('.json', '.txt')
        with open(text_path, 'w', encoding='utf-8') as f:
            for i, text in enumerate(texts[:100]):  # Save first 100 for inspection
                f.write(f"=== Training Text {i+1} ===\n")
                f.write(text)
                f.write("\n\n")
        
        print(f"✅ Saved {len(texts)} training texts")
        print(f"📄 JSON file: {output_path}")
        print(f"📄 Text file: {text_path}")
    
    def prepare_all_data(self, data_paths: Dict[str, str], output_path: str = "training_data/islamic_training_data.json"):
        """Prepare all training data"""
        print("🚀 Starting data preparation...")
        
        all_texts = []
        
        # Load Quran data
        if 'quran' in data_paths:
            quran_texts = self.load_quran_data(data_paths['quran'])
            all_texts.extend(quran_texts)
        
        # Load Hadith data
        if 'hadith_bukhari' in data_paths:
            bukhari_texts = self.load_hadith_data(data_paths['hadith_bukhari'])
            all_texts.extend(bukhari_texts)
        
        if 'hadith_muslim' in data_paths:
            muslim_texts = self.load_hadith_data(data_paths['hadith_muslim'])
            all_texts.extend(muslim_texts)
        
        # Load Tafsir data
        if 'tafsir_fatihah' in data_paths:
            tafsir_texts = self.load_tafsir_data(data_paths['tafsir_fatihah'])
            all_texts.extend(tafsir_texts)
        
        # Create training pairs
        training_texts = self.create_training_pairs(all_texts)
        
        # Save training data
        self.save_training_data(training_texts, output_path)
        
        # Print statistics
        print("\n📊 Data Statistics:")
        print(f"Total texts: {len(training_texts)}")
        print(f"Average length: {sum(len(text) for text in training_texts) / len(training_texts):.1f} characters")
        print(f"Texts with <ayah>: {sum(1 for text in training_texts if '<ayah>' in text)}")
        print(f"Texts with <hadith>: {sum(1 for text in training_texts if '<hadith>' in text)}")
        print(f"Texts with <question>: {sum(1 for text in training_texts if '<question>' in text)}")
        
        return training_texts

def main():
    """Main data preparation function"""
    
    # Data paths
    data_paths = {
        'quran': 'assets/data/quran/complete_quran.json',
        'hadith_bukhari': 'assets/data/hadith/sahih_bukhari.json',
        'hadith_muslim': 'assets/data/hadith/sahih_muslim.json',
        'tafsir_fatihah': 'assets/data/quran/tafsir_al_fatihah.json',
    }
    
    # Check if data files exist
    missing_files = []
    for source, path in data_paths.items():
        if not os.path.exists(path):
            missing_files.append(f"{source}: {path}")
    
    if missing_files:
        print("❌ Missing data files:")
        for missing in missing_files:
            print(f"  - {missing}")
        return
    
    # Create processor
    processor = IslamicDataProcessor()
    
    # Prepare data
    training_texts = processor.prepare_all_data(data_paths)
    
    print("\n🎉 Data preparation completed successfully!")
    print(f"📁 Training data saved to: training_data/islamic_training_data.json")

if __name__ == "__main__":
    main()
