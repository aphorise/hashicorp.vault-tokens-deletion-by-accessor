#!/usr/bin/env ruby
# // This scripts is for revoking Vault tokens that were issues in the past before
# // a particular date & using it's ACCESSOR_ID.
# // for more details see: https://github.com/hashicorp/vault-ruby/blob/master/lib/vault/api/auth_token.rb

require 'vault';

tSTART = Time.now;  # // START TIME FOR MEASURING SPEED
puts "Running Ruby: #{__FILE__}\n\n";

# // Vault API URL:
Vault.address = "http://192.168.178.101:8200";  # Also reads from ENV["VAULT_ADDR"] if not set.
Vault.token   = "root";
Vault.ssl_verify = false;

VDATE_OLDER = Time.parse("2019-12-31 21:55:17 UTC");  # // Accessor tokens prior or equal to this date are removed.
VEXCLUDE_ACCESSORS = ["1mSILWuB0CXdpu4eIOgrM27X"];  # // ROOT & other tokens to ommit.

rAccessors = Vault.auth_token.accessors;

# pp rAccessors.data[:keys]
iVTOTAL = rAccessors.data[:keys].length;

iV_REVOKED_TOKENS = 0;
for aAccessor in rAccessors.data[:keys]
    rAccessor_Lookup = Vault.auth_token.lookup_accessor(aAccessor.to_s);
    # pp rAccessor_Lookup; Time.parse(rAccessor_Lookup.data[:issue_time]);
    if Time.parse(rAccessor_Lookup.data[:issue_time]) <= VDATE_OLDER
        if VEXCLUDE_ACCESSORS.include?(aAccessor.to_s)
            puts "EXCLUDED: #{aAccessor.to_s} - skipping ...";
            next;
        end;

        if Vault.auth_token.revoke_accessor(aAccessor.to_s)
            iV_REVOKED_TOKENS += 1;  # // increase counter for seeing how many were deleted
        end;
    end;
end;

puts "\nREMOVED: #{iV_REVOKED_TOKENS}/#{iVTOTAL} accessor tokens.\n\n";

tEND = Time.now;
tDIFF = (tEND - tSTART);
puts "Ruby ACCESSOR TOKENS DELETION TOOK: #{tDIFF} seconds to complete.";
