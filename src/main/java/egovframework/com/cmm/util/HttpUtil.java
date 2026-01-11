package egovframework.com.cmm.util;

import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

/**
 * HTTP 응답 유틸리티 클래스
 */
public class HttpUtil {

    /**
     * 성공 응답 생성 (Page 객체)
     */
    public static <T> ResponseEntity<Page<T>> createResultOk(Page<T> data) {
        return new ResponseEntity<>(data, HttpStatus.OK);
    }

    /**
     * 성공 응답 생성 (일반 객체)
     */
    public static <T> ResponseEntity<T> createResultOk(T data) {
        return new ResponseEntity<>(data, HttpStatus.OK);
    }

    /**
     * 에러 응답 생성
     */
    public static <T> ResponseEntity<T> createResultError(HttpStatus status) {
        return new ResponseEntity<>(status);
    }

    /**
     * 에러 응답 생성 (메시지 포함)
     */
    public static <T> ResponseEntity<T> createResultError(T data, HttpStatus status) {
        return new ResponseEntity<>(data, status);
    }
}
