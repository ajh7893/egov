package egovframework.com.cmm.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * 전자정부 프레임워크 Properties 유틸리티
 */
public class EgovProperties {

    private static Properties properties = new Properties();

    static {
        try (InputStream input = EgovProperties.class.getClassLoader()
                .getResourceAsStream("egovframework/egovProps/globals.properties")) {
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Property 값 조회
     * @param key 키
     * @return 값
     */
    public static String getProperty(String key) {
        return properties.getProperty(key);
    }

    /**
     * Property 값 조회 (기본값 포함)
     * @param key 키
     * @param defaultValue 기본값
     * @return 값
     */
    public static String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }
}
