package com.aialpha.sentiment.service;

import com.aialpha.sentiment.config.S3Properties;
import com.aialpha.sentiment.model.SentimentResult;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
public class S3StorageService {

    private final S3Client s3;
    private final ObjectMapper mapper = new ObjectMapper();
    private final S3Properties props;

    public S3StorageService(S3Properties props) {
        this.props = props;
        String reg = System.getenv().getOrDefault("AWS_REGION",
                     System.getenv().getOrDefault("AWS_DEFAULT_REGION", "eu-west-1"));
        this.s3 = S3Client.builder()
                .region(Region.of(reg))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }

    public void storeResult(SentimentResult result) {
        String prefix = props.getResultsPrefix();

        Instant now = Instant.now();
        String y = DateTimeFormatter.ofPattern("yyyy").withZone(ZoneOffset.UTC).format(now);
        String m = DateTimeFormatter.ofPattern("MM").withZone(ZoneOffset.UTC).format(now);

        // use getter (POJO), fall back to random if null/blank
        String rid = null;
        try { rid = result.getRequestId(); } catch (Exception ignored) {}
        if (rid == null || rid.isBlank()) rid = UUID.randomUUID().toString();

        String key = String.format("%s/%s/%s/%s.json", prefix, y, m, rid);

        try {
            String body = mapper.writeValueAsString(result);
            PutObjectRequest put = PutObjectRequest.builder()
                    .bucket(props.getBucketName())
                    .key(key)
                    .contentType("application/json")
                    .build();
            s3.putObject(put, RequestBody.fromString(body, StandardCharsets.UTF_8));
        } catch (Exception e) {
            throw new RuntimeException("S3 putObject failed: " + e.getMessage(), e);
        }
    }
}
