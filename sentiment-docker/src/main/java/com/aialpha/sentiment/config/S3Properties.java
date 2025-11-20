package com.aialpha.sentiment.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "s3")
public class S3Properties {
    private String bucketName;
    private String resultsPrefix = "sentiment-results";

    public String getBucketName() {
        return bucketName;
    }

    public void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    public String getResultsPrefix() {
        return resultsPrefix;
    }

    public void setResultsPrefix(String resultsPrefix) {
        this.resultsPrefix = resultsPrefix;
    }
}
