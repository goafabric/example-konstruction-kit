import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

val javaVersion = "25"
java.sourceCompatibility = JavaVersion.toVersion(javaVersion)
tasks.withType<KotlinCompile>().all { compilerOptions { jvmTarget.set(JvmTarget.fromTarget(javaVersion)); javaParameters = true } }

val dockerRegistry = "goafabric"

plugins {
	java
	jacoco
	id("io.quarkus") version "3.34.3"
	id("net.researchgate.release") version "3.1.0"
	id("org.sonarqube") version "7.2.3.7755"
	id("info.solidsoft.pitest") version "1.19.0"

	kotlin("jvm") version "2.3.20"
	kotlin("plugin.jpa") version "2.3.20"
	kotlin("plugin.allopen") version "2.3.20"
	kotlin("kapt") version "2.3.20"
}

repositories {
	mavenCentral()
}

dependencies {
	constraints {
		annotationProcessor("org.mapstruct:mapstruct-processor:1.6.3")
		implementation("org.mapstruct:mapstruct:1.6.3")
		implementation("io.quarkiverse.azureservices:quarkus-azure-storage-blob:1.2.2")

		kapt("org.mapstruct:mapstruct-processor:1.6.3")
		kapt("org.hibernate.orm:hibernate-processor:7.3.1.Final")

		testImplementation("org.assertj:assertj-core:3.27.7")
		testImplementation("com.tngtech.archunit:archunit-junit5:1.4.1")
		testImplementation("org.mockito.kotlin:mockito-kotlin:6.3.0")
	}

	//kapt(enforcedPlatform("io.quarkus:quarkus-bom:3.34.1"))
	implementation(enforcedPlatform("io.quarkus:quarkus-bom:3.34.3"))
}
dependencies {
	//web
	implementation("io.quarkus:quarkus-arc")
	implementation("io.quarkus:quarkus-resteasy-jackson")
	implementation("org.jboss.logmanager:log4j2-jboss-logmanager")

	//monitoring
	implementation("io.quarkus:quarkus-smallrye-health")
	implementation("io.quarkus:quarkus-micrometer-registry-prometheus")
	implementation("io.quarkus:quarkus-smallrye-openapi")
	implementation("io.quarkus:quarkus-opentelemetry")
	implementation("io.opentelemetry.instrumentation:opentelemetry-jdbc")

	//crosscutting
	implementation("io.quarkus:quarkus-hibernate-validator")

	//persistence
	implementation("io.quarkus:quarkus-jdbc-postgresql")
	implementation("io.quarkus:quarkus-jdbc-h2")
	implementation("io.quarkus:quarkus-flyway")
	implementation("org.flywaydb:flyway-database-postgresql")

	//jakarta data
	implementation("io.quarkus:quarkus-hibernate-panache-next")
	implementation("jakarta.data:jakarta.data-api")
	kapt("org.hibernate.orm:hibernate-processor")

	//adapter
	implementation("io.quarkus:quarkus-resteasy-client-jackson")
	implementation("io.quarkus:quarkus-smallrye-fault-tolerance")

	//jib
	implementation("io.quarkus:quarkus-container-image-jib")

	//code generation
	implementation("org.mapstruct:mapstruct")
	kapt("org.mapstruct:mapstruct-processor")

	//kotlin
	implementation("io.quarkus:quarkus-kotlin")
	implementation("com.fasterxml.jackson.module:jackson-module-kotlin")

	//kafka
	implementation("io.quarkus:quarkus-messaging-kafka")
	implementation("io.smallrye.reactive:smallrye-reactive-messaging-kafka")

	//blob
	implementation("io.quarkiverse.azureservices:quarkus-azure-storage-blob")

	//h2
	runtimeOnly("com.h2database:h2")

	//test
	testImplementation("io.quarkus:quarkus-junit5")
	testImplementation("io.rest-assured:rest-assured")
	testImplementation("io.quarkus:quarkus-resteasy-client-jackson")
	testImplementation("io.quarkus:quarkus-jacoco")
	testImplementation("org.assertj:assertj-core")
	testImplementation("com.tngtech.archunit:archunit-junit5")

	testImplementation("org.mockito.kotlin:mockito-kotlin")
	testImplementation("io.quarkus:quarkus-junit-mockito")

	testImplementation("io.quarkus:quarkus-test-kafka-companion")

	//pitest
	pitest("org.pitest:pitest-junit5-plugin:1.2.3")
}

tasks.withType<Test> {
	useJUnitPlatform()
	exclude("**/*NRIT*")
	systemProperty("java.util.logging.manager", "org.jboss.logmanager.LogManager")
	finalizedBy("jacocoTestReport")
}

tasks.jacocoTestReport {
	executionData.setFrom(
		fileTree(layout.buildDirectory.get()).include("jacoco/test.exec", "jacoco-quarkus.exec")
	)
	reports { xml.required.set(true); csv.required.set(true); html.required.set(true) }
}

tasks.register<Exec>("dockerImageNative") { description = "native image"; group = "build" ; dependsOn("quarkusBuild", "testNative")
	if (gradle.startParameter.taskNames.contains("dockerImageNative")) {
		if (System.getProperty("os.arch").equals("aarch64")) {
			System.setProperty("quarkus.jib.platforms", "linux/arm64/v8")
		}

		System.setProperty("quarkus.native.builder-image", "quay.io/quarkus/ubi-quarkus-mandrel-builder-image:jdk-25")
		System.setProperty("quarkus.package.jar.enabled", "false")

		System.setProperty("quarkus.native.enabled", "true")
		System.setProperty("quarkus.native.container-build", "true")
		System.setProperty("quarkus.container-image.build", "true")

		System.setProperty("quarkus.native.native-image-xmx", "8000m")
		System.setProperty("quarkus.container-image.image", "${dockerRegistry}/${project.name}:${project.version}")

		commandLine("/bin/sh", "-c", "docker push ${dockerRegistry}/${project.name}:${project.version}")
	}
}

configure<net.researchgate.release.ReleaseExtension> {
	buildTasks.set(listOf("build", "test", "dockerImageNative"))
	tagTemplate.set("v${version}".replace("-SNAPSHOT", ""))
}


allOpen {
	annotation("jakarta.ws.rs.Path")
	annotation("jakarta.enterprise.context.ApplicationScoped")
	annotation("jakarta.persistence.Entity")
	annotation("io.quarkus.test.junit.QuarkusTest")
}

sonarqube {
	properties {
		property("sonar.exclusions", "**/.github/workflows/**")
	}
}

tasks.matching { it.name == "checkSnapshotDependencies" }.configureEach {
	enabled = false
}

pitest {
	testStrengthThreshold = 60
	targetClasses.set(listOf("org.goafabric.*"))
	targetTests.set(listOf("*.*Test"))
	excludedClasses.add("*.ApplicationBaseRuntimeHints")
}