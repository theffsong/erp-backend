FROM gradle:8.5-jdk17 AS build
WORKDIR /app
COPY . .
# 복사한 코드를 바탕으로 그래들 빌드를 실행해서 jar로 실행
# gradlew는 git에 실행 권한 없이 올라가 있어서 chmod 필요
# bootJar만 실행해서 실행 가능한 jar 하나만 생성 (build는 -plain.jar까지 만들어 COPY가 실패함)
RUN chmod +x gradlew && ./gradlew clean bootJar -x test --no-daemon
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Xmx256m", "-jar", "app.jar"]
