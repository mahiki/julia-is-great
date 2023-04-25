#=  ================================================================================================
    ODBC attempt connection to TrinoDB at work

    starburst provides a driver: https://docs.starburst.io/data-consumer/clients/odbc.html
    
=   ===============================================================================================#

# 1. download and install the driver .dmg for ARM architecture
# 2. open "/Library/starburst/starburstodbc/Starburst ODBC Driver Install and Configuration Guide.pdf"
# 3. Driver manager included, no need for: brew install unixodbc

using ODBC
using DataFrames

host = "trino-adhoc.corp.zacs-prod.zg-int.net"
port = "443"
drivername = "trino"
TRINO_CREDS = Dict(
    "user" => ENV["TRINO_USER"]
    , "password"=> ENV["TRINO_PASSWORD"]
    )
driverpath = "/Library/starburst/starburstodbc/lib/libstarburstodbc_sb64-universal.dylib"
official_connstring = "Driver=$(drivername);Host=$(host);Port=$(port);AuthenticationType=LDAP Authentication"

# MAKE CONNECTION #
# =============== #
ODBC.adddriver("trino", driverpath)
ODBC.drivers()
    # Dict{String, String} with 1 entry:
    # "trino" => "Installed"


conn = ODBC.Connection(official_connstring, TRINO_CREDS["user"], TRINO_CREDS["password"])
    # ERROR: HY000: [Starburst][Trino] (1040) Error with HTTP request, response code: 400
    # FIX: add "AuthenticationType=LDAP Authentication" to the conn string
# ODBC.Connection(Driver=trino;Host=trino-adhoc.corp.zacs-prod.zg-int.net;Port=443;AuthenticationType=LDAP Authentication)
# SUCCESS!

# QUERY SOMETHING TO DATAFRAME #
# ============================ #
query = Dict()
query["cat"] = "show catalogs;"
query["date"] = "select current_date as today;"


df = DBInterface.execute(conn, query["cat"]) |> DataFrame
# ─────┼───────────
#    1 │ hive
#    3 │ snowflake              WE ARE IN BUSINESS

df = DBInterface.execute(conn, query["date"]) |> DataFrame
    # 1×1 DataFrame
    #  Row │ today
        #  │ Date
    # ─────┼────────────
    #    1 │ 2023-02-11
