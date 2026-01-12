<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }
        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            min-width: 500px;
            max-width: 600px;
        }
        .modal-header {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #007bff;
        }
        .modal-body {
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: vertical;
            min-height: 100px;
            box-sizing: border-box;
        }
        .modal-footer {
            text-align: right;
        }
        .modal-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
            font-size: 14px;
        }
        .btn-confirm {
            background-color: #007bff;
            color: white;
        }
        .btn-confirm:hover {
            background-color: #0056b3;
        }
        .btn-cancel {
            background-color: #6c757d;
            color: white;
        }
        .btn-cancel:hover {
            background-color: #5a6268;
        }
        .error-message {
            color: red;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="modal-overlay" id="excelDownloadModal">
        <div class="modal-content">
            <div class="modal-header">
                엑셀 다운로드
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="downloadReason">다운로드 사유 <span style="color: red;">*</span></label>
                    <textarea id="downloadReason" name="downloadReason" placeholder="엑셀 다운로드 사유를 입력해주세요."></textarea>
                    <div class="error-message" id="reasonError">다운로드 사유를 입력해주세요.</div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="modal-btn btn-cancel" onclick="closeModal()">취소</button>
                <button class="modal-btn btn-confirm" onclick="confirmDownload()">확인</button>
            </div>
        </div>
    </div>

    <script>
        function closeModal() {
            $('#excelDownloadModal').remove();
        }

        function confirmDownload() {
            var reason = $('#downloadReason').val().trim();
            if (!reason) {
                $('#reasonError').show();
                return;
            }
            $('#reasonError').hide();

            // 부모 윈도우의 콜백 함수 호출
            if (window.excelDownloadCallback) {
                window.excelDownloadCallback(reason);
            }
        }

        // ESC 키로 모달 닫기
        $(document).on('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal();
            }
        });

        // 오버레이 클릭 시 모달 닫기
        $('.modal-overlay').on('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
    </script>
</body>
</html>
