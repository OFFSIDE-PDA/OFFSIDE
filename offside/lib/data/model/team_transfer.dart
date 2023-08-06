import 'package:flutter/widgets.dart';

List<String> teamK1 = <String>[
  "강원 FC",
  "광주 FC",
  "대구 FC",
  "대전\n하나 시티즌",
  "FC 서울",
  "수원 삼성\n블루윙즈",
  "수원 FC",
  "울산 현대",
  "인천\n유나이티드",
  "전북 현대\n모터스",
  "제주\n유나이티드",
  "포항\n스틸러스"
];
List<String> teamK2 = <String>[
  "경남 FC",
  "김천 상무 FC",
  "김포 FC",
  "부산\n아이파크",
  "부천 FC\n1995",
  "서울 이랜드 FC",
  "성남 FC",
  "안산\n그리너스 FC",
  "FC 안양",
  "전남\n드래곤즈",
  "충남\n아산 FC",
  "충북\n청주 FC",
  "천안\n시티 FC"
];

Map<String, dynamic> teamTransfer = {
  '강원 FC': {
    'name': '강원',
    'img': Image.asset('images/K1_png/Gangwon.png'),
    'site': "https://www.gangwon-fc.com/",
    'year': 2008,
    'city': "강원도 강릉시",
    'stadium': "강릉 종합운동장",
    'stadium_img': 'images/stadium/k1/gangwon.jpg',
  },
  '광주 FC': {
    'name': '광주',
    'img': Image.asset('images/K1_png/GwangJu.png'),
    'site': "https://www.gwangjufc.com/",
    'year': 2010,
    'city': "광주광역시",
    'stadium': "광주 축구전용구장",
    'stadium_img': 'images/stadium/k1/gwangju.jpg',
  },
  '대구 FC': {
    'name': '대구',
    'img': Image.asset('images/K1_png/Daegu.png'),
    'site': "https://daegufc.co.kr/main/",
    'year': 2002,
    'city': "대구광역시",
    'stadium': "DGB 대구은행 파크",
    'stadium_img': 'images/stadium/k1/daegu.jpg',
  },
  '대전 하나 시티즌': {
    'name': '대전',
    'img': Image.asset('images/K1_png/Daejeon.png'),
    'site': "https://www.dhcfc.kr/",
    'year': 1997,
    'city': "대전광역시",
    'stadium': "대전 월드컵 경기장",
    'stadium_img': 'images/stadium/k1/daejeon.jpeg',
  },
  'FC 서울': {
    'name': '서울',
    'img': Image.asset('images/K1_png/Seoul.png'),
    'site': "https://m.fcseoul.com/",
    'year': 1983,
    'city': "서울특별시",
    'stadium': "서울 월드컵 경기장",
    'stadium_img': 'images/stadium/k1/seoul.jpg',
  },
  '수원 삼성 블루윙즈': {
    'name': '수원',
    'img': Image.asset('images/K1_png/suwon.png'),
    'site': "http://www.bluewings.kr/",
    'year': 1995,
    'city': "경기도 수원특례시",
    'stadium': "수원 월드컵 경기장",
    'stadium_img': 'images/stadium/k1/samsung.jpg',
  },
  '수원 FC': {
    'name': '수원FC',
    'img': Image.asset('images/K1_png/suwonFC.png'),
    'site': "https://www.suwonfc.com/",
    'year': 2003,
    'city': "경기도 수원특례시",
    'stadium': "수원 종합운동장",
    'stadium_img': 'images/stadium/k1/suwon.jpg',
  },
  '울산 현대': {
    'name': '울산',
    'img': Image.asset('images/K1_png/ulsan.png'),
    'site': "https://www.uhfc.tv/",
    'year': 1983,
    'city': "울산광역시",
    'stadium': "울산 문수 축구경기장",
    'stadium_img': 'images/stadium/k1/ulsan.jpg',
  },
  '인천 유나이티드': {
    'name': '인천',
    'img': Image.asset('images/K1_png/incheon.png'),
    'site': "https://www.incheonutd.com/main/index.php",
    'year': 2003,
    'city': "인천광역시",
    'stadium': "인천 축구전용경기장",
    'stadium_img': 'images/stadium/k1/incheon.jpeg',
  },
  '전북 현대 모터스': {
    'name': '전북',
    'img': Image.asset('images/K1_png/jeonbuk.png'),
    'site': "https://hyundai-motorsfc.com/",
    'year': 1994,
    'city': "전라북도 전주시",
    'stadium': "전주 월드컵 경기장",
    'stadium_img': 'images/stadium/k1/jeonbuk.png',
  },
  '제주 유나이티드': {
    'name': '제주',
    'img': Image.asset('images/K1_png/jeju.png'),
    'site': "https://www.jeju-utd.com/",
    'year': 1982,
    'city': "제주특별자치도",
    'stadium': "제주 월드컵 경기장",
    'stadium_img': 'images/stadium/k1/jeju.jpg',
  },
  '포항 스틸러스': {
    'name': '포항',
    'img': Image.asset('images/K1_png/pohang.png'),
    'site': "https://www.steelers.co.kr/",
    'year': 1973,
    'city': "경상북도 포항시",
    'stadium': "포항 스틸야드",
    'stadium_img': 'images/stadium/k1/pohang.jpg',
  },
  '경남 FC': {
    'name': '경남',
    'img': Image.asset('images/K2_png/kn.png'),
    'site': "https://www.gyeongnamfc.com/",
    'year': 2006,
    'city': "경상남도 창원시",
    'stadium': "창원 축구센터",
    'stadium_img': 'images/stadium/k2/kyeongnam.jpeg',
  },
  '김천 상무 FC': {
    'name': '김천',
    'img': Image.asset('images/K2_png/kimcheon.png'),
    'site': "https://www.gimcheonfc.com/index.php",
    'year': 1984,
    'city': "경상북도 김천시",
    'stadium': "김천 종합운동장",
    'stadium_img': 'images/stadium/k2/gimcheon.jpg',
  },
  '김포 FC': {
    'name': '김포',
    'img': Image.asset('images/K2_png/kimpo.png'),
    'site': "https://www.gimpofc.co.kr/",
    'year': 2013,
    'city': "경기도 김포시",
    'stadium': "김포 솔터 축구장",
    'stadium_img': 'images/stadium/k2/gimpo.jpeg',
  },
  '부산 아이파크': {
    'name': '부산',
    'img': Image.asset('images/K2_png/busan.png'),
    'site': "https://www.busanipark.com/",
    'year': 1979,
    'city': "부산광역시",
    'stadium': "부산 아시아드 주경기장",
    'stadium_img': 'images/stadium/k2/busan.jpeg',
  },
  '부천 FC 1995': {
    'name': '부천',
    'img': Image.asset('images/K2_png/bc.jpg'),
    'site': "http://bfc1995.com/site/main/index112",
    'year': 2007,
    'city': "경기도 부천시",
    'stadium': "부천 종합운동장",
    'stadium_img': 'images/stadium/k2/bucheon.PNG',
  },
  '서울 이랜드 FC': {
    'name': '서울E',
    'img': Image.asset('images/K2_png/seoulE.png'),
    'site': "https://www.seoulelandfc.com/",
    'year': 2014,
    'city': "서울특별시",
    'stadium': "목동 종합운동장",
    'stadium_img': 'images/stadium/k2/seoulE.jpg',
  },
  '성남 FC': {
    'name': '성남',
    'img': Image.asset('images/K2_png/seongnam.png'),
    'site': "https://shopsfc.com/",
    'year': 1989,
    'city': "경기도 성남시",
    'stadium': "탄천 종합운동장",
    'stadium_img': 'images/stadium/k2/seongnam.jpg',
  },
  '안산 그리너스 FC': {
    'name': '안산',
    'img': Image.asset('images/K2_png/ansan.png'),
    'site': "https://www.greenersfc.com/",
    'year': 2017,
    'city': "경기도 안산시",
    'stadium': "안산 와스타디움",
    'stadium_img': 'images/stadium/k2/ansan.jpg',
  },
  'FC 안양': {
    'name': '안양',
    'img': Image.asset('images/K2_png/anyang.png'),
    'site': "https://www.fc-anyang.com/",
    'year': 2013,
    'city': "경기도 안양시",
    'stadium': "안양 종합운동장",
    'stadium_img': 'images/stadium/k2/anyang.jpg',
  },
  '전남 드래곤즈': {
    'name': '전남',
    'img': Image.asset('images/K2_png/jeonnam.png'),
    'site': "https://www.dragons.co.kr/",
    'year': 1994,
    'city': "전라남도 광양시",
    'stadium': "광양 축구전용구장",
    'stadium_img': 'images/stadium/k2/jeonnam.jpg',
  },
  '충남 아산 FC': {
    'name': '아산',
    'img': Image.asset('images/K2_png/asan.png'),
    'site': "https://www.asanfc.com/index.php",
    'year': 1996,
    'city': "충청남도 아산시",
    'stadium': "아산 이순신 종합운동장",
    'stadium_img': 'images/stadium/k2/asan.jpg',
  },
  '충북 청주 FC': {
    'name': '청주',
    'img': Image.asset('images/K2_png/chungju.png'),
    'site': "http://chfc.kr/",
    'year': 2002,
    'city': "충청북도 청주시",
    'stadium': "청주 종합운동장",
    'stadium_img': 'images/stadium/k2/cheongju.jpg',
  },
  '천안 시티 FC': {
    'name': '천안',
    'img': Image.asset('images/K2_png/cheonan.png'),
    'site': "https://cheonancityfc.kr/",
    'year': 2008,
    'city': "충청남도 천안시",
    'stadium': "천안 종합운동장",
    'stadium_img': 'images/stadium/k2/cheonan.jpg',
  }
};
