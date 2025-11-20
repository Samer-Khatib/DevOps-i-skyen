package com.aialpha.sentiment.config;

import io.micrometer.cloudwatch2.CloudWatchConfig;
import io.micrometer.cloudwatch2.CloudWatchMeterRegistry;
import io.micrometer.core.instrument.Clock;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.cloudwatch.CloudWatchAsyncClient;

import java.time.Duration;

@Configuration
public class MetricsConfig {

    @Bean
    public CloudWatchAsyncClient cloudWatchAsyncClient(
            @Value("${AWS_REGION:eu-west-1}") String region) {
        return CloudWatchAsyncClient.builder()
                .region(Region.of(region))
                .build();
    }

    @Bean
    public CloudWatchConfig cloudWatchConfig(
            @Value("${metrics.cloudwatch.namespace:}") String namespaceFromProps,
            @Value("${metrics.cloudwatch.step:PT1M}") Duration step) {
        final String ns = (namespaceFromProps == null || namespaceFromProps.isBlank())
                ? System.getenv().getOrDefault("METRICS_NAMESPACE", "SentimentApp-12345")
                : namespaceFromProps;

        return new CloudWatchConfig() {
            @Override public String namespace() { return ns; }
            @Override public Duration step() { return step; }
            @Override public String get(String k) { return null; }
        };
    }

    @Bean
    public MeterRegistry meterRegistry(CloudWatchConfig config,
                                       CloudWatchAsyncClient client) {
        return new CloudWatchMeterRegistry(config, Clock.SYSTEM, client);
    }
}
