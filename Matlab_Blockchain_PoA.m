function main()
   
    difficulty_target = '0000';

    
    unique_ids = {
        '12@!GnHki*',
        'HZmq6}(m:v',
        'BEc7;v2UP-',
        'PsLEWbK:_q',
        'z3bpA/JyuI',
        'oS~5tK^`\z',
        'ZweDp4*Q0b',
        'olI}FG0oIc',
        'wlAPokh|a>',
        '&U6^]oL$Hw',

    };

    
    function hash = hash_block(block)
        block_str = num2str(block);
        hash = DataHash(block_str, struct( ...
            'Method', ...
            'SHA-256', ...
            'Format', ...
            'hex'));
    end

   
    function nonce = proof_of_authority(index, hash_of_previous_block, transactions)
        nonce = 0;
        while ~valid_proof(index, hash_of_previous_block, transactions, nonce)
            nonce = nonce + 1;
        end
    end

   
    function valid = valid_proof(index, hash_of_previous_block, transactions, nonce)
        content = strcat('(', num2str(index), hash_of_previous_block, transactions, num2str(nonce), ')');
        content_hash = DataHash(content, struct( ...
            'Method', ...
            'SHA-256', ...
            'Format', ...
            'hex'));
        valid = startsWith(content_hash, difficulty_target);
    end

    
    function [block, current_transactions] = append_block(chain, current_transactions, nonce, hash_of_previous_block)
        block.index = length(chain) + 1;  % Nomor urut blok dalam rantai.
        block.timestamp = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');  % Waktu ketika blok ditambang.
        block.transactions = current_transactions;  % Daftar transaksi dalam blok.
        block.nonce = nonce;  % Nilai nonce yang dipilih untuk proof-of-authority.
        block.hash_of_previous_block = hash_of_previous_block;  % Hash dari blok sebelumnya dalam rantai.
        
        current_transactions = {};  % Mengosongkan daftar transaksi yang belum ditambahkan.
        chain = [chain, block];  % Menambahkan blok baru ke rantai.
    end

   
    function current_transactions = add_transaction(current_transactions, sender, recipient, amount)
        current_transactions{end+1} = struct( ...
            'amount', amount, ...
            'recipient', recipient, ...
            'sender', sender);
    end

  
    function valid = validate_unique_id(unique_id)
        valid = any(strcmp(unique_id, unique_ids));
    end

    start_time = datetime('now');  % Waktu awal program dimulai
    chain = {};  % Rantai blok dalam blockchain.
    current_transactions = {};  % Daftar transaksi yang belum ditambahkan ke blok manapun.

   
    genesis_hash = hash_block('genesis_block');
    [block, current_transactions] = append_block(chain, current_transactions, proof_of_authority(0, genesis_hash, []), genesis_hash);

    node_identifier = 'sample_node_identifier';  % Menggunakan identifier sederhana saja.

   
    unique_id = input('Masukkan Unique ID: ', 's');  % Meminta unique ID dari pengguna.
    if validate_unique_id(unique_id)
        current_transactions = add_transaction(current_transactions, '0', node_identifier, 1);  % Menambahkan transaksi baru.
        
       
        transactions_str = '';
        for i = 1:length(current_transactions)
            transaction = current_transactions{i};
            transactions_str = strcat(transactions_str, num2str(transaction.amount), transaction.recipient, transaction.sender);
        end
        
        if ~isempty(chain)
            last_block_hash = hash_block(chain(end).hash_of_previous_block);  % Menghitung hash blok terakhir.
        else
          
            last_block_hash = genesis_hash;
        end
        
        index = length(chain) + 1;  % Nomor urut blok baru.
        nonce = proof_of_authority(index, last_block_hash, transactions_str);  % Melakukan proof-of-authority.
        [block, current_transactions] = append_block(chain, current_transactions, nonce, last_block_hash);  % Menambahkan blok baru ke rantai.

       
        disp('Blok baru telah ditambahkan (ditambang)');
        disp(['Indeks: ', num2str(block.index)]);
        disp(['Hash Blok Sebelumnya: ', block.hash_of_previous_block]);
        disp(['Nonce: ', num2str(block.nonce)]);
        disp('Transaksi:');
        disp(block.transactions);
    else
        disp('Unique ID Tidak Valid!');
    end

    end_time = datetime('now');  % Waktu akhir program
    disp(['Total Waktu Komputasi: ', char(duration(end_time - start_time))]);  % Cetak waktu komputasi keseluruhan
end
