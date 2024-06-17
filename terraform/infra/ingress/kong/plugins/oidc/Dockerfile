FROM kong:3.6.0

USER root

#ENV KONG_PLUGINS=bundled,strip-prefix,security-headers,oidc
ENV KONG_PLUGINS=bundled,oidc

# Add oidc plugin
ADD ./plugin /usr/local/share/lua/5.1/kong/plugins/oidc

# Install dependencies
RUN luarocks install lua-resty-openidc 1.7.1-1

USER kong
