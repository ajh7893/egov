package egovframework.com.cmm.util;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * 보안 유틸리티 클래스
 * SEED 암호화/복호화 기능 제공
 */
public class SecurityUtil {

    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/ECB/PKCS5Padding";

    /**
     * SEED 암호화 (실제로는 AES 사용)
     * @param key 암호화 키 (16자리)
     * @param plainText 평문
     * @return 암호화된 문자열 (Base64)
     */
    public static String encryptBySeed(String key, String plainText) {
        try {
            if (plainText == null || plainText.isEmpty()) {
                return "";
            }

            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), ALGORITHM);
            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);

            byte[] encrypted = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(encrypted);
        } catch (Exception e) {
            throw new RuntimeException("암호화 중 오류가 발생했습니다.", e);
        }
    }

    /**
     * SEED 복호화 (실제로는 AES 사용)
     * @param key 복호화 키 (16자리)
     * @param encryptedText 암호화된 문자열 (Base64)
     * @return 복호화된 평문
     */
    public static String decryptBySeed(String key, String encryptedText) {
        try {
            if (encryptedText == null || encryptedText.isEmpty()) {
                return "";
            }

            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), ALGORITHM);
            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            cipher.init(Cipher.DECRYPT_MODE, secretKey);

            byte[] decoded = Base64.getDecoder().decode(encryptedText);
            byte[] decrypted = cipher.doFinal(decoded);
            return new String(decrypted, StandardCharsets.UTF_8);
        } catch (Exception e) {
            // 복호화 실패 시 기본값 반환
            return "nullnullnull";
        }
    }
}
