package com.aialpha.sentiment.metrics;

import io.micrometer.core.instrument.*;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class SentimentMetrics {

    private final MeterRegistry meterRegistry;
    private final AtomicInteger lastCompanyCount = new AtomicInteger(0);

    public SentimentMetrics(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
        Gauge.builder("sentiment.company.last_count", lastCompanyCount, AtomicInteger::get)
                .description("Company count from the last analysis")
                .register(meterRegistry);
    }

    public void recordAnalysis(String sentiment, String company) {
        Counter.builder("sentiment.analysis.total")
                .tag("sentiment", sentiment)
                .tag("company", company)
                .description("Total number of sentiment analysis requests")
                .register(meterRegistry)
                .increment();
    }

    public void recordDuration(long milliseconds, String company, String model) {
        Timer.builder("bedrock.latency.seconds")          // <-- IMPORTANT
                .description("Latency of the analysis pipeline")
                .tag("company", company)
                .tag("model", model)
                .publishPercentileHistogram()
                .register(meterRegistry)
                .record(milliseconds, TimeUnit.MILLISECONDS);
    }

    public void recordCompaniesDetected(int count) {
        lastCompanyCount.set(count);
    }

    public void recordConfidence(double confidence, String sentiment, String company) {
        DistributionSummary.builder("sentiment.confidence")
                .description("Confidence distribution across results (0.0-1.0)")
                .tag("sentiment", sentiment)
                .tag("company", company)
                .maximumExpectedValue(1.0)
                .minimumExpectedValue(0.0)
                .publishPercentileHistogram()
                .register(meterRegistry)
                .record(confidence);
    }
}
