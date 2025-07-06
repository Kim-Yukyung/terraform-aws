// 배포 정보 표시
document.addEventListener('DOMContentLoaded', function() {
    // 배포 시간 표시
    const deployTime = new Date().toLocaleString('ko-KR');
    document.getElementById('deploy-time').textContent = deployTime;
    
    // 사용자 에이전트 표시
    const userAgent = navigator.userAgent;
    document.getElementById('user-agent').textContent = userAgent.substring(0, 50) + '...';
    
    // 언어 표시
    const language = navigator.language || navigator.userLanguage;
    document.getElementById('language').textContent = language;
    
    // 페이지 로드 완료 메시지
    console.log('🚀 AWS S3 + CloudFront 정적 웹사이트가 성공적으로 로드되었습니다!');
    
    // 애니메이션 효과
    animateElements();
});

// 요소들에 애니메이션 효과 추가
function animateElements() {
    const cards = document.querySelectorAll('.feature-card');
    
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 200);
    });
}

// 페이지 성능 정보 표시 (개발자 도구에서 확인 가능)
window.addEventListener('load', function() {
    if ('performance' in window) {
        const perfData = performance.getEntriesByType('navigation')[0];
        console.log('📊 페이지 로드 시간:', perfData.loadEventEnd - perfData.loadEventStart, 'ms');
        console.log('🌐 DNS 조회 시간:', perfData.domainLookupEnd - perfData.domainLookupStart, 'ms');
        console.log('🔗 연결 시간:', perfData.connectEnd - perfData.connectStart, 'ms');
    }
}); 
