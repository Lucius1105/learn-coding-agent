#!/usr/bin/env python3
"""
开拍 (Kaipai) API 客户端
用于自动化视频剪辑处理
"""

import requests
import hmac
import hashlib
import time
import json
from pathlib import Path

class KaipaiClient:
    """开拍 API 客户端"""
    
    BASE_URL = "https://api.kaipai.com/v1"
    
    def __init__(self, api_key, secret_key):
        self.api_key = api_key
        self.secret_key = secret_key
    
    def _generate_signature(self, timestamp, method, path, body=""):
        """生成 HMAC-SHA256 签名"""
        message = f"{timestamp}{method}{path}{body}"
        signature = hmac.new(
            self.secret_key.encode(),
            message.encode(),
            hashlib.sha256
        ).hexdigest()
        return signature
    
    def _get_headers(self, method, path, body=""):
        """获取请求头"""
        timestamp = str(int(time.time()))
        signature = self._generate_signature(timestamp, method, path, body)
        return {
            "X-API-Key": self.api_key,
            "X-Signature": signature,
            "X-Timestamp": timestamp,
            "Content-Type": "application/json"
        }
    
    def upload_video(self, file_path):
        """上传视频文件"""
        path = "/upload"
        url = f"{self.BASE_URL}{path}"
        
        timestamp = str(int(time.time()))
        headers = {
            "X-API-Key": self.api_key,
            "X-Signature": self._generate_signature(timestamp, "POST", path),
            "X-Timestamp": timestamp
        }
        
        with open(file_path, 'rb') as f:
            files = {'file': f}
            response = requests.post(url, headers=headers, files=files)
        
        return response.json()
    
    def create_edit_task(self, video_id, style="talking_head", captions=True, language="zh"):
        """创建网感剪辑任务"""
        path = "/tasks/edit"
        url = f"{self.BASE_URL}{path}"
        
        body = json.dumps({
            "video_id": video_id,
            "style": style,
            "captions": captions,
            "language": language
        })
        
        headers = self._get_headers("POST", path, body)
        response = requests.post(url, headers=headers, data=body)
        
        return response.json()
    
    def create_enhance_task(self, video_id, resolution="1080p"):
        """创建画质修复任务"""
        path = "/tasks/enhance"
        url = f"{self.BASE_URL}{path}"
        
        body = json.dumps({
            "video_id": video_id,
            "resolution": resolution
        })
        
        headers = self._get_headers("POST", path, body)
        response = requests.post(url, headers=headers, data=body)
        
        return response.json()
    
    def get_task_status(self, task_id):
        """查询任务状态"""
        path = f"/tasks/{task_id}"
        url = f"{self.BASE_URL}{path}"
        
        headers = self._get_headers("GET", path)
        response = requests.get(url, headers=headers)
        
        return response.json()
    
    def download_video(self, video_url, output_path):
        """下载处理后的视频"""
        response = requests.get(video_url, stream=True)
        
        with open(output_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        return output_path


# 使用示例
if __name__ == "__main__":
    # 初始化客户端
    client = KaipaiClient(
        api_key="5f6c135620f549cab7b347a2a659d492",
        secret_key="59e630075fbf46c9a5c431d87a9587cc"
    )
    
    # 示例：处理视频
    # 1. 上传视频
    # result = client.upload_video("/path/to/video.mp4")
    # video_id = result.get("video_id")
    # 
    # 2. 创建剪辑任务
    # task = client.create_edit_task(video_id)
    # task_id = task.get("task_id")
    # 
    # 3. 查询任务状态
    # status = client.get_task_status(task_id)
    # print(status)
    
    print("开拍 API 客户端已初始化")
    print("使用方法：")
    print("  client.upload_video('视频路径') - 上传视频")
    print("  client.create_edit_task('video_id') - 创建网感剪辑任务")
    print("  client.create_enhance_task('video_id') - 创建画质修复任务")
    print("  client.get_task_status('task_id') - 查询任务状态")
