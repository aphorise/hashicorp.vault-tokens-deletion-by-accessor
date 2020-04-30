# HashiCorp **`vault`** old tokens revocation
The provided script leverages [vault-ruby gem](https://github.com/hashicorp/vault-ruby/) to delete all tokens that are older than a particular date using their `accessor_id`.

The script can be helpful toward cleaning up leases that are associated with (`/auth`) tokens and which may otherwise have not had TTL's appropriately set or reduced to as lower value as possible (minutes or hours recommended for as shorter duration as possible).

:warning: **DO NOT EXECUTE THIS IN PRODUCTION - unless you've made backups with methods to revert in cases of issues or accidental deletion and are confident to continue.** :warning:

Refer to the contents of **`vault-tokens-deletion-by-accessor.rb`** for setting the date / threshold that's consider too old and no longer needed.

```bash
nano vault-tokens-deletion-by-accessor.rb ;
 # Vault.address = "http://192.168.178.101:8200";
 # Vault.token   = "root";
 # // ^^ set address & credentials.
 # VDATE_OLDER = Time.parse("2019-12-31 21:55:17 UTC");
 # // ^^ set to your needs
 # VEXCLUDE_ACCESSORS = ["1mSILWuB0CXdpu4eIOgrM27X"];
 # // ^^ set accessor_id's not to remove - eg ROOT or others expected to be old.

gem install vault ;
 # // install vault libraries

ruby vault-tokens-deletion-by-accessor.rb ;
 # Running Ruby: vault_token_deletions_by_accessor.rb
 #
 # EXCLUDED: 1mSILWuB0CXdpu4eIOgrM27X - skipping ...
 #  
 # REMOVED: 2/4 accessor tokens.
 # Ruby ACCESSOR TOKENS DELETION TOOK: 0.006492 seconds.
```


## Notes
This is intended as a mere practise exercise.

See [Vault api-docs/libraries](https://www.vaultproject.io/api-docs/libraries) for other application specific frameworks which may be used in authoring other / similar tools to help automate interactions with Vault. 

Equivilant API methods related accessors are detailed at [api-docs/auth/token](https://www.vaultproject.io/api-docs/auth/token).

------
