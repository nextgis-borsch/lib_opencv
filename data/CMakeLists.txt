file(GLOB HAAR_CASCADES haarcascades/*.xml)
file(GLOB LBP_CASCADES lbpcascades/*.xml)

install(FILES ${HAAR_CASCADES} DESTINATION ${INSTALL_SHARE_DIR}/haarcascades COMPONENT libs)
install(FILES ${LBP_CASCADES}  DESTINATION ${INSTALL_SHARE_DIR}/lbpcascades  COMPONENT libs)
