import 'package:flutter/material.dart';

class Book {
  String name;
  String image;
  String description;
  double rate;
  int page;
  String categoryBook;
  String language;

  Book({
    required this.name,
    required this.image,
    required this.description,
    required this.rate,
    required this.page,
    required this.categoryBook,
    required this.language,
  });
}

List<Book> listBook = [
  Book(
    name: 'Redhat',
    image: 'images/redhat.png',
    description: '''
Red Hat adalah salah satu perusahaan terbesar dan dikenal untuk 
dedikasinya atas perangkat lunak sumber terbuka. Red Hat didirikan pada 1993 dan 
bermarkas di Raleigh, North Carolina, Amerika Serikat. Red Hat dikenal karena 
produknya Red Hat Linux, salah satu distro Linux utama.
''',
    rate: 4.3,
    page: 229,
    categoryBook: 'Sysadmin IDN',
    language: 'IDN',
  ),

  Book(
    name: 'Docker',
    image: 'images/buku-docker.png',
    description: '''
Docker adalah sekumpulan platform sebagai produk layanan yang 
menggunakan virtualisasi tingkat OS untuk mengirimkan perangkat lunak dalam paket 
yang disebut kontainer.
''',
    rate: 4.2,
    page: 210,
    categoryBook: 'Sysadmin IDN',
    language: 'IDN',
  ),

  Book(
    name: 'Hyper-V',
    image: 'images/hyper-v.png',
    description: '''
Hyper-V adalah teknologi virtualisasi yang dikembangkan oleh Microsoft. 
Hyper-V memungkinkan pengguna untuk menjalankan beberapa sistem operasi secara bersamaan 
pada satu komputer fisik dengan memanfaatkan hypervisor.
''',
    rate: 4.2,
    page: 210,
    categoryBook: 'Sysadmin IDN',
    language: 'IDN',
  ),

  Book(
    name: 'NMS',
    image: 'images/nms.png',
    description: '''
Network Monitoring System (NMS) merupakan tool untuk melakukan 
monitoring pada elemen-elemen dalam jaringan komputer.
Fungsi dari NMS adalah melakukan pemantauan terhadap kualitas 
SLA (Service Level Agreement) dari bandwidth yang digunakan.
''',
    rate: 4.4,
    page: 210,
    categoryBook: 'Sysadmin IDN',
    language: 'IDN',
  ),

  Book(
    name: 'VPN',
    image: 'images/vpn.png',
    description: '''
Virtual Private Network (VPN) atau jaringan pribadi maya 
memperluas jaringan pribadi di jaringan publik dan memungkinkan 
pengguna untuk mengirim dan menerima data seolah-olah perangkat mereka 
terhubung langsung ke jaringan pribadi.
''',
    rate: 4.4,
    page: 210,
    categoryBook: 'Network IDN',
    language: 'IDN',
  ),

  Book(
    name: 'Openstack',
    image: 'images/openstack.png',
    description: '''
OpenStack adalah perangkat lunak bebas dan open-source 
untuk cloud computing yang sebagian besar digunakan sebagai 
Infrastructure as a Service (IaaS), di mana server virtual dan 
sumber daya lainnya tersedia untuk pelanggan.
''',
    rate: 4.5,
    page: 210,
    categoryBook: 'Network IDN',
    language: 'IDN',
  ),
];