# based on https://github.com/nownabe/metabase-gae
FROM gcr.io/google-appengine/openjdk

EXPOSE 8080

# https://github.com/metabase/metabase/issues/3734
ENV PORT 8080
ENV MB_PORT 8080
ENV MB_JETTY_PORT 8080
ENV MB_DB_PORT 5432
ENV METABASE_SQL_INSTANCE <*** INSERT HERE FULL NAME FOR CLOUD SQL INSTANCE ***>

ENV JAVA_OPTS "-XX:+IgnoreUnrecognizedVMOptions -Dfile.encoding=UTF-8 --add-opens=java.base/java.net=ALL-UNNAMED --add-modules=java.xml.bind"

ADD https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 ./cloud_sql_proxy
ADD http://downloads.metabase.com/latest/metabase.jar /metabase.jar

RUN chmod +x ./cloud_sql_proxy

# https://github.com/metabase/metabase/issues/3983#issuecomment-268068993
# CMD ["java", "-jar", "/metabase.jar"]
CMD ./cloud_sql_proxy -instances=$METABASE_SQL_INSTANCE=tcp:$MB_DB_PORT & java -jar ./metabase.jar
