module MyModule::FileStorageRewards {

    use aptos_framework::coin;
    use aptos_framework::signer;
    use aptos_framework::aptos_coin::{AptosCoin};

    struct StorageProvider has store, key {
        provider: address,
        storage_size: u64, // Storage size in GB
        is_rewarded: bool,
    }

    // Function to register unused storage space
    public fun register_storage(provider: &signer, storage_size: u64) {
        let new_provider = StorageProvider {
            provider: signer::address_of(provider),
            storage_size,
            is_rewarded: false,
        };
        move_to(provider, new_provider);
    }

    // Function to reward users for sharing storage space
    public fun reward_provider(provider: &signer, reward_amount: u64) acquires StorageProvider {
        let storage = borrow_global_mut<StorageProvider>(signer::address_of(provider));

        // Ensure provider has not been rewarded yet
        assert!(!storage.is_rewarded, 1);

        // Transfer reward tokens to the provider
        coin::transfer<AptosCoin>(provider, signer::address_of(provider), reward_amount);

        // Mark as rewarded
        storage.is_rewarded = true;
    }
}
