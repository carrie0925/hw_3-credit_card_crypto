# frozen_string_literal: true

module DoubleTranspositionCipher
  def self.encrypt(document, key)
    # 1. find number of rows/cols such that matrix is almost square
    size = document.length
    cols = Math.sqrt(size).ceil
    rows = (size.to_f / cols).ceil
    
    # 2. break plaintext into evenly sized blocks
    matrix = Array.new(rows) { Array.new(cols, ' ') }
    document.chars.each_with_index do |char, idx|
      row, col = idx.divmod(cols)
      matrix[row][col] = char
    end
    
    # 3. sort rows in predictibly random way using key as seed
    rng = Random.new(key)
    row_order = (0...rows).to_a.shuffle(random: rng)
    shuffled_rows = row_order.map { |i| matrix[i].dup }
    
    # 4. sort columns of each row in predictibly random way
    shuffled_rows.map! do |row|
      col_order = (0...cols).to_a.shuffle(random: rng)
      col_order.map { |i| row[i] }
    end
    
    # 5. return joined cyphertext
    shuffled_rows.flatten.join
  end

  def self.decrypt(ciphertext, key)
    # 1. Determine dimensions for the original matrix
    size = ciphertext.length
    cols = Math.sqrt(size).ceil
    rows = (size.to_f / cols).ceil
    
    # 2. Initialize random generator with the same key
    rng = Random.new(key)
    
    # 3. Generate the same row and column orderings as used in encryption
    row_order = (0...rows).to_a.shuffle(random: rng)
    
    # Calculate the inverse row ordering (to undo the row shuffle)
    inverse_row = Array.new(rows)
    row_order.each_with_index { |original, shuffled| inverse_row[original] = shuffled }
    
    # 4. Create column orderings for each row
    col_orders = rows.times.map do
      (0...cols).to_a.shuffle(random: rng)
    end
    
    # Calculate inverse column orderings for each row
    inverse_col_orders = col_orders.map do |order|
      inverse = Array.new(cols)
      order.each_with_index { |original, shuffled| inverse[original] = shuffled }
      inverse
    end
    
    # 5. Recreate the shuffled matrix
    chars = ciphertext.chars
    shuffled_matrix = Array.new(rows) { |i| chars.slice(i * cols, cols) || [] }
    
    # 6. Undo the column shuffling
    unshuffled_cols = shuffled_matrix.each_with_index.map do |row, row_idx|
      col_order = inverse_col_orders[row_idx]
      new_row = Array.new(cols, ' ')
      row.each_with_index do |char, col_idx|
        new_row[col_order[col_idx]] = char if col_idx < row.length
      end
      new_row
    end
    
    # 7. Undo the row shuffling
    unshuffled_matrix = Array.new(rows) { Array.new(cols, ' ') }
    unshuffled_cols.each_with_index do |row, shuffled_idx|
      unshuffled_matrix[inverse_row[shuffled_idx]] = row
    end
    
    # 8. Flatten the matrix and join into a string, trim any trailing spaces
    unshuffled_matrix.flatten.join.rstrip
  end
end