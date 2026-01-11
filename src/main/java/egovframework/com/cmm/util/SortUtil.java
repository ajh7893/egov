package egovframework.com.cmm.util;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.stream.Collectors;

/**
 * 정렬 유틸리티 클래스
 * Spring Data의 Sort를 MyBatis ORDER BY 절로 변환
 */
public class SortUtil {

    /**
     * Pageable의 Sort 정보를 SQL ORDER BY 절로 변환
     * @param pageable Pageable 객체
     * @return ORDER BY 절 문자열
     */
    public static String toOrderByClause(Pageable pageable) {
        if (pageable == null || pageable.getSort() == null || pageable.getSort().isUnsorted()) {
            return "";
        }

        return pageable.getSort().stream()
                .map(order -> {
                    String column = camelToSnake(order.getProperty());
                    String direction = order.getDirection() == Sort.Direction.ASC ? "ASC" : "DESC";
                    return column + " " + direction;
                })
                .collect(Collectors.joining(", "));
    }

    /**
     * CamelCase를 snake_case로 변환
     * @param camelCase CamelCase 문자열
     * @return snake_case 문자열
     */
    private static String camelToSnake(String camelCase) {
        if (camelCase == null || camelCase.isEmpty()) {
            return camelCase;
        }

        return camelCase.replaceAll("([a-z])([A-Z]+)", "$1_$2").toUpperCase();
    }
}
