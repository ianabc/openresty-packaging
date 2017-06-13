FROM centos:7
MAINTAINER "Ian Allison" <iana@pims.math.ca>

# Install required packages for building
RUN yum install -y \
  gcc \
  git \
  make \
  rpm-build \
  redhat-rpm-config \
  rpmdevtools \
  sudo \
  yum-utils

# Install required packages for building openresty
RUN yum install -y \
  openssl-devel \
  zlib-devel \
  pcre-devel \
  gcc \
  make \
  perl \
  perl-Data-Dumper \
  libtool \
  ElectricFence \
  systemtap-sdt-devel \
  valgrind-devel

RUN yum-config-manager -y --add-repo https://openresty.org/package/centos/openresty.repo

RUN yum install -y openresty-openssl-devel \
  openresty-zlib-devel \
  openresty-pcre-devel \
  openresty-openssl-debug-devel \
  perl-ExtUtils-MakeMaker \
  perl-Template-Toolkit \
  perl-Test \
  perl-Test-Simple \
  perl-IPC-Run3 \
  perl-CPAN \
  perl-File-Find-Rule \
  perl-List-MoreUtils \
  perl-Test-Base \
  perl-Test-LongString \
  perl-Test-Differences
  
RUN useradd makerpm && groupadd mock && usermod -a -G mock makerpm

WORKDIR /home/makerpm

USER makerpm

RUN rpmdev-setuptree

# Get specs and sources
ADD rpm/SPECS/* rpmbuild/SPECS/
ADD rpm/SOURCES/* rpmbuild/SOURCES/

ADD makerpm.sh .

USER root
RUN chown -R makerpm:makerpm /home/makerpm
USER makerpm

CMD ./makerpm.sh
