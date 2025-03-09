# frozen_string_literal: true

module SubstitutionCipher
  module Caesar
    # Encrypts document using key
    # Arguments:
    #   document: String or CreditCard
    #   key: Fixnum (integer)
    # Returns: String
    def self.encrypt(document, key)
      # Convert CreditCard to string if needed
      text = document.to_s
      
      text.chars.map do |char|
        # Convert to ASCII code, add key, and convert back to character
        ((char.ord + key) % 128).chr
      end.join
    end

    # Decrypts String document using integer key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.decrypt(document, key)
      document.chars.map do |char|
        # Convert to ASCII code, subtract key, and convert back to character
        # Add 128 before modulo to handle negative numbers
        ((char.ord - key + 128) % 128).chr
      end.join
    end
  end

  module Permutation
    # Encrypts document using key
    # Arguments:
    #   document: String or CreditCard
    #   key: Fixnum (integer)
    # Returns: String
    def self.encrypt(document, key)
      # Convert CreditCard to string if needed
      text = document.to_s
      
      # Create a random mapping based on the key
      random = Random.new(key)
      char_map = (0..127).to_a.shuffle(random: random)
      
      # Apply the mapping to encrypt
      text.chars.map do |char|
        char_map[char.ord].chr
      end.join
    end

    # Decrypts String document using integer key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.decrypt(document, key)
      # Recreate the same random mapping based on the key
      random = Random.new(key)
      char_map = (0..127).to_a.shuffle(random: random)
      
      # Create a reverse mapping for decryption
      reverse_map = Array.new(128)
      char_map.each_with_index do |value, index|
        reverse_map[value] = index
      end
      
      # Apply the reverse mapping to decrypt
      document.chars.map do |char|
        reverse_map[char.ord].chr
      end.join
    end
  end
end