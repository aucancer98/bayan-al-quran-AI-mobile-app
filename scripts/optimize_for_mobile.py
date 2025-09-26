#!/usr/bin/env python3
"""
Script to optimize trained Islamic AI model for mobile deployment
Converts PyTorch model to TensorFlow Lite for Flutter integration
"""

import torch
import tensorflow as tf
from transformers import TFAutoModelForCausalLM, AutoTokenizer
import numpy as np
import json
import os
from pathlib import Path

class MobileModelOptimizer:
    """Optimize model for mobile deployment"""
    
    def __init__(self, model_path: str):
        self.model_path = model_path
        self.output_path = "assets/models"
        
    def convert_to_tflite(self, model_name: str = "islamic_model.tflite"):
        """Convert PyTorch model to TensorFlow Lite"""
        
        # Load the trained model
        print("Loading trained model...")
        tokenizer = AutoTokenizer.from_pretrained(self.model_path)
        
        # Convert to TensorFlow
        print("Converting to TensorFlow...")
        tf_model = TFAutoModelForCausalLM.from_pretrained(
            self.model_path, 
            from_tf=False
        )
        
        # Create a simple inference function
        @tf.function
        def inference_func(input_ids, attention_mask):
            outputs = tf_model(input_ids=input_ids, attention_mask=attention_mask)
            return outputs.logits
        
        # Create concrete function
        print("Creating concrete function...")
        concrete_func = inference_func.get_concrete_function(
            input_ids=tf.TensorSpec(shape=[1, 512], dtype=tf.int32),
            attention_mask=tf.TensorSpec(shape=[1, 512], dtype=tf.int32)
        )
        
        # Save as SavedModel
        saved_model_path = os.path.join(self.output_path, "saved_model")
        tf.saved_model.save(tf_model, saved_model_path)
        
        # Convert to TensorFlow Lite
        print("Converting to TensorFlow Lite...")
        converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_path)
        
        # Optimization settings
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        converter.target_spec.supported_types = [tf.float16]  # Use float16 for smaller size
        converter.target_spec.supported_ops = [
            tf.lite.OpsSet.TFLITE_BUILTINS,
            tf.lite.OpsSet.SELECT_TF_OPS
        ]
        
        # Convert
        tflite_model = converter.convert()
        
        # Save TensorFlow Lite model
        os.makedirs(self.output_path, exist_ok=True)
        tflite_path = os.path.join(self.output_path, model_name)
        
        with open(tflite_path, 'wb') as f:
            f.write(tflite_model)
        
        print(f"TensorFlow Lite model saved to {tflite_path}")
        
        # Get model size
        model_size = os.path.getsize(tflite_path) / (1024 * 1024)  # MB
        print(f"Model size: {model_size:.2f} MB")
        
        return tflite_path
    
    def create_vocabulary(self, tokenizer, vocab_path: str = "islamic_vocab.json"):
        """Create vocabulary file for Flutter"""
        
        vocab = tokenizer.get_vocab()
        vocab_list = [token for token, _ in sorted(vocab.items(), key=lambda x: x[1])]
        
        vocab_data = {
            "vocab": vocab_list,
            "vocab_index": vocab,
            "vocab_size": len(vocab_list),
            "special_tokens": {
                "pad_token": tokenizer.pad_token,
                "unk_token": tokenizer.unk_token,
                "bos_token": tokenizer.bos_token,
                "eos_token": tokenizer.eos_token,
            }
        }
        
        # Save vocabulary
        vocab_file_path = os.path.join(self.output_path, vocab_path)
        with open(vocab_file_path, 'w', encoding='utf-8') as f:
            json.dump(vocab_data, f, ensure_ascii=False, indent=2)
        
        print(f"Vocabulary saved to {vocab_file_path}")
        return vocab_file_path
    
    def create_model_config(self, model_path: str, vocab_path: str):
        """Create model configuration file"""
        
        config = {
            "model_name": "Islamic AI Model",
            "version": "1.0.0",
            "model_path": model_path,
            "vocab_path": vocab_path,
            "max_sequence_length": 512,
            "vocab_size": 10000,
            "model_type": "causal_lm",
            "language": "arabic",
            "description": "Custom Islamic AI model trained on Quran, Hadith, and Islamic texts",
            "training_data": [
                "Quran",
                "Sahih Bukhari",
                "Sahih Muslim",
                "Tafsir Ibn Kathir"
            ],
            "capabilities": [
                "word_analysis",
                "hadith_search",
                "quranic_insights",
                "thematic_analysis"
            ]
        }
        
        config_path = os.path.join(self.output_path, "model_config.json")
        with open(config_path, 'w', encoding='utf-8') as f:
            json.dump(config, f, ensure_ascii=False, indent=2)
        
        print(f"Model configuration saved to {config_path}")
        return config_path
    
    def optimize_model(self):
        """Complete optimization pipeline"""
        
        print("Starting model optimization for mobile...")
        
        # Convert to TensorFlow Lite
        tflite_path = self.convert_to_tflite()
        
        # Load tokenizer for vocabulary
        tokenizer = AutoTokenizer.from_pretrained(self.model_path)
        
        # Create vocabulary
        vocab_path = self.create_vocabulary(tokenizer)
        
        # Create model configuration
        config_path = self.create_model_config(
            os.path.basename(tflite_path),
            os.path.basename(vocab_path)
        )
        
        print("Model optimization completed successfully!")
        print(f"Output directory: {self.output_path}")
        print(f"Files created:")
        print(f"  - {os.path.basename(tflite_path)} (TensorFlow Lite model)")
        print(f"  - {os.path.basename(vocab_path)} (Vocabulary)")
        print(f"  - {os.path.basename(config_path)} (Configuration)")

def main():
    """Main optimization function"""
    
    # Path to trained model
    model_path = "./islamic_model"
    
    if not os.path.exists(model_path):
        print(f"Error: Model path {model_path} does not exist")
        print("Please train the model first using train_islamic_model.py")
        return
    
    # Create optimizer
    optimizer = MobileModelOptimizer(model_path)
    
    # Optimize model
    optimizer.optimize_model()

if __name__ == "__main__":
    main()
