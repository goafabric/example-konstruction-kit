FROM kong:3.8.0

USER root

ENV KONG_PLUGINS=bundled,oidc

# Add oidc plugin
ADD ./plugin /usr/local/share/lua/5.1/kong/plugins/oidc

# Install dependencies
RUN luarocks remove lua-resty-session 4.0.5-1 --force #https://github.com/revomatico/kong-oidc/issues/34
RUN luarocks install lua-resty-openidc 1.7.6-3
RUN luarocks list

USER kong
