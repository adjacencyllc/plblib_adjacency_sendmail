// test sendmail library
    include "lib_adjacency_sendmail.inc"

errorCode integer 2
recipientAddresses init "nonsuch@adjacency.net"
subject init "[TEST] lib_adjacency_sendmail"
mailBody dim 1024
attachmentList dim 1024
iniSection init "SENDMAIL_UNITTEST"
timestamp dim 16
timestampFormat init "9999-99-99 99:99:99.99"

    display *it,*hd;

    clock timestamp into timestamp
    edit timestamp into timestampFormat
    pack mailBody from "This is a test message from the sendmail unit test. It was sent at ",timestampFormat,"."
    call SENDMAIL_SEND giving errorCode using recipientAddresses:
                                              subject:
                                              mailBody:
                                              attachmentList:
                                              iniSection
    display "Sendmail test result: ",errorCode
    display " S$ERROR$: ",*ll,S$ERROR$
    stop
