return function(conf, ctx)
    local core = require("apisix.core")
    local cjson = require("cjson")

    -- Retrieve the X-Userinfo header
    local userinfo = core.request.header(ctx, "X-Userinfo")

    -- Check if the header exists
    if userinfo then
        -- Decode the base64-encoded string
        local decodedUserinfo = ngx.decode_base64(userinfo)

        -- Decode the JSON string into a Lua table
        local decodedUserinfoJson = cjson.decode(decodedUserinfo)

        -- Extract the id from the first entry of the urn:goafabric:claims:institution array
        local institution = decodedUserinfoJson["urn:goafabric:claims:institution"]
        local id = nil
        if institution and type(institution) == "table" and #institution > 0 then
            id = institution[1]["id"]
        end

        -- Set X-TenantId header with the extracted id value
        if id then
            core.request.add_header("X-TenantId", id)
        end
    end
end
