FROM fedora:27

# Setup volumes for input and output
VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Dependency versions
ENV FAKER_VERSION 4.2.0
ENV GECKO_DRIVER_VERSION v0.19.1
ENV ROBOT_FRAMEWORK_VERSION 3.0.2
ENV SELENIUM_LIBRARY_VERSION 3.0.1

# Install system dependencies
RUN dnf upgrade -y \
  && dnf install -y \
    chromedriver \
    chromium \
    firefox \
    python2-pip-9.0.1-* \
    xauth \
    xorg-x11-server-Xvfb-1.19.* \
    which \
    wget \
  && dnf clean all

# Install Robot Framework and Selenium Library
RUN pip install \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  robotframework-faker==$FAKER_VERSION \
  robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
  robotframework-xvfb

# Download Gecko drivers directly from the GitHub repository
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
      && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
      && mkdir /opt/robotframework/drivers/ \
      && mv geckodriver /opt/robotframework/drivers/geckodriver \
      && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz

# Prepare binaries to be executed
RUN mkdir /opt/robotframework/bin; \
    cp /bin/chromedriver /opt/robotframework/bin/; \
    cp /bin/chromium-browser /opt/robotframework/bin/

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original \
  && ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Execute all robot tests
CMD ["robot", "/opt/robotframework/tests/"]
