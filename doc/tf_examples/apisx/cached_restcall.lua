local http = require("resty.http")
local cjson = require("cjson")
local mlcache = require("resty.mlcache")

-- Create an HTTP client
local httpc = http.new()

-- Define the endpoint URL
local url = "https://api.example.com/resource"

-- Create an instance of mlcache
local cache, err = mlcache.new("my_cache", {
    shm = "my_cache", -- shared memory zone name
    lru_size = 100,   -- number of items to keep in the cache
    ttl = 60,         -- time to live in seconds
})

-- Check for errors in creating the cache instance
if not cache then
    ngx.say("Failed to create cache: ", err)
    return
end

-- Define a cache key based on the URL
local cache_key = "api_response:" .. url

-- Try to retrieve the response from cache
local cached_response, err = cache:get(cache_key)

-- If the response is not in the cache, make the API request
if not cached_response then
    -- Make the HTTP request
    local res, err = httpc:request_uri(url, {
        method = "GET",
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer YOUR_ACCESS_TOKEN"
        }
    })

    -- Check if there was an error
    if not res then
        ngx.say("Failed to request: ", err)
        return
    end

    -- Cache the response
    cache:set(cache_key, res.body)
    cached_response = res.body
end

-- Decode the cached response body from JSON
local data = cjson.decode(cached_response)

-- Access the cached data
ngx.say("Cached response body: ", cjson.encode(data))

-- Close the HTTP client connection
httpc:close()
