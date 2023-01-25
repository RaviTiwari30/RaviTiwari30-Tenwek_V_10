<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CPOEFolder.aspx.cs" Inherits="Design_CPOE_CPOEFolder" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title></title>
     <%-- // Start of Style for menu dropdown--%>

  <style>
      /* Fixed sidenav, full height */
      .sidenav {
          height: 100%;
          width: 200px;
          position: fixed;
          z-index: 1;
          top: 0;
          left: 0;
          background-color: #0a335e;
          overflow-x: hidden;
          padding-top: 0px;
      }

          /* Style the sidenav links and the dropdown button */
          .sidenav a, .dropdown-btn {
              text-decoration: none;
              font-size: 12px;
              color: white;
              display: grid;
              border: none;
              background: #0a335e;
              width: 100%;
              text-align: left;
              cursor: pointer;
              outline: none;
              margin-top: -15px;
          }

              /* On mouse-over */
              .sidenav a:hover, .dropdown-btn:hover {
                  color: #f1f1f1;
              }

      /* Main content */
      .main {
          margin-left: 200px; /* Same as the width of the sidenav */
          font-size: 10px; /* Increased text to enable scrolling */
      }

      /* Add an active class to the active dropdown button */
      .active {
          background-color: green;
          color: white;
      }

      /* Dropdown container (hidden by default). Optional: add a lighter background color and some left padding to change the design of the dropdown content */
      .dropdown-container {
          display: none;
          background-color: #262626;
          margin-top: -10px;
          margin-bottom: 10px;
      }

      /* Optional: Style the caret down icon */
      .fa-caret-down {
          float: right;
      }

      /* Some media queries for responsiveness */
      @media screen and (max-height: 450px) {
          .sidenav {
              padding-top: 15px;
          }

              .sidenav a {
                  font-size: 18px;
              }
      }
  </style>

<%--    // End Of Style For Menu DropDown--%>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/foldercss") %>
    <form id="form1" runat="server">
        <div style="padding-top: 60px; padding-left: 150px; padding-right: 0px;" id="divViewer" class="paddingwrap">
            <iframe name="pagecontent" id="pagecontent" frameborder="0" scrolling="yes" src="<%=ViewState["defaultUrl"].ToString()%>?TID=<%=Request.QueryString["TID"].ToString()+"&TransactionID="+Util.GetString(Request.QueryString["TID"])+"&PatientID="+PatientID+"&PID="+Request.QueryString["PatientID"].ToString()+"&App_ID="+Request.QueryString["App_ID"].ToString()+"&LnxNo="+Request.QueryString["LnxNo"].ToString() %>"></iframe>
        </div>

      <div style="overflow-y: auto; height: 86%" id="sidebar-left">
            <div id="leftPanel" class="paddingwrap">
<div class="dropdown">
                 <asp:Repeater ID="rptMainMenu" runat="server" OnItemDataBound="rptMainMenu_ItemDataBound">
        <ItemTemplate>
            <asp:Label runat="server" Visible="false" Text='<%#Eval("MenuName") %>' ID="lblMenuName"> </asp:Label>
  <button type="button"  class="dropdown-btn" style="width: 100%; padding:4px;text-align: left; max-width: 300px; overflow: hidden; text-overflow: ellipsis;"> <%#Eval("MenuName") %>  </button>
  <asp:Repeater ID="rptChildMenu" runat="server">
  <HeaderTemplate>
      <div class="dropdown-container">
                        <table cellspacing="0" cellpadding="1" rules="all" border="1" id="tblMenuMaster" style="background-color: transparent; border-color: Transparent; border-width: 1px; border-style: None; width: 100%; border-collapse: collapse;">
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
 <tr>
                            <td style="border: solid 1px transparent">
                                <a href='<%#Eval("URL")+"?TID="+Util.GetString(Request.QueryString["TID"])+"&TransactionID="+Util.GetString(Request.QueryString["TID"])+"&PatientID="+PatientID+"&IsEdit="+IsDone+"&PID="+PatientID+"&IsEdit="+IsDone+"&LnxNo="+LnxNo+"&typeoftnx=CPOE&App_ID="+App_ID+"&Sex"+Sex+"&PanelID="+PanelID+"&LabType=OPD&IsIPD=0&MenuID="+Eval("id")+"&notettypeID=&PatientCreationtblid=&DeptID="+Util.GetString(Request.QueryString["DeptID"])  %>' target="pagecontent">
                                    <button type="button" style="width: 100%; text-align: left; max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><%#Eval("MenuName") %> </button>
                                </a>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </tbody>
                         </table>
                         </div>
                    </FooterTemplate>
                </asp:Repeater>            
        </ItemTemplate>
    </asp:Repeater>
</div></div>
        </div>
        
          









        <div style="overflow-y: auto; height: 545px; display: none" id="sidebar-right">
            <div class="easyui-accordion" style="margin: 1px 1px 1px 1px; background-color: transparent; width: 148px; display: inline-block; box-shadow: 0px 0px 5px #a0a0a0; /*border: solid 4px #efefef; border-radius: 5px; */padding: 1px 1px 1px 1px;">
                <div id="divVitalDetails" title="Patient Vitals">
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td style="text-align: center"></td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">Temperature</td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">
                                    <label class="accordionlabel" id="lblTemp"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Pulse</td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">
                                    <label class="accordionlabel" id="lblPulse"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">B/P</td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">
                                    <label class="accordionlabel" id="lblBp"></label>
                                </td>

                            </tr>
                            <tr>
                                <td style="text-align: center">Blood Sugar</td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">
                                    <label class="accordionlabel" id="lblBS"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Resp.</td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">
                                    <label class="accordionlabel" id="lblResp"></label>
                                </td>

                            </tr>
                            <tr>
                                <td style="text-align: center">SPO2</td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">
                                    <label class="accordionlabel" id="lblSpO2"></label>
                                </td>

                            </tr>
                        </table>
                    </div>
                </div>
                <div title="OutStanding" style="overflow: auto;">
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td style="text-align: center"></td>

                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" onclick="pendingAmount()" id="lblPendingAmount"></label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div id="divBillDetails" title="Billing Details" style="overflow: auto;">
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td style="text-align: center"></td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Bill Amount </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblBillAmount"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Discount</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblDiscount"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Net Amount</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblNetAmt"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Advance</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblAdvanceAmount"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Round off</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblRoundoff"></label>
                                </td>
                            </tr>

                            <tr>
                                <td style="text-align: center">Total Deduction</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblTotalDeduction"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Tax (%)</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblTaxPer"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Tax Amtount</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblTaxAmount"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Net Bill Amount</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblNetBillAmount"></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center">Remaining</td>
                            </tr>
                            <tr>
                                <td style="text-align: center">
                                    <label class="accordionlabel" id="lblRemaining"></label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div id="header">
            <div class="row">
                <div class="col-md-1">
                    <img id="imgPatient" runat="server" alt="Patient Photo" src="../../Images/MaleDefault.png" onmouseover="ShowPatientPhoto(this.src,1)" onmouseout="ShowPatientPhoto(this.src,0)" />
                </div>
                <div class="col-md-21">
                    <div style="margin-top: 1px;" class="row">
                        <div class="col-md-3">
                            <label class="pull-left bold">Patient Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <label id="lblPatientName" class="pull-left patientInfo"></label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left bold">Gender </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <label id="lblGender" class="pull-left patientInfo"></label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left bold">Age </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <label id="lblAge" class="pull-left patientInfo">CASH</label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left bold">App. Date/No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <label id="lblAppointmentDate" class="pull-left patientInfo"></label>
                        </div>
                    </div>
                    <div style="margin-top: 1px;" class="row">
                        <div class="col-md-3">
                            <label class="pull-left bold">Current Doctor </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <label id="lblDoctorName" class="pull-left patientInfo"></label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left bold">UHID </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <label id="lblPatientID" class="pull-left patientInfo"></label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left bold">Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <label id="lblPanel" style="max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" class="pull-left patientInfo"></label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left bold">PurposeOfVisit</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <label id="lblPurposeOfVisit" style="max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" class="pull-left patientInfo"></label>
                        </div>
                    </div>
                    <div style="margin-top: 1px;" class="row">
                        <div style="display:none" class="col-md-3">
                            <label class="pull-left bold">File Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div style="display:none" class="col-md-5">
                            <input id="txtFileName" style="height: 19px;" type="text" />
                        </div>
                        <div style="display:none"  class="col-md-7">
                            <button type="button" style="height: 18px;" class="button" id="record">Record</button>
                            <button type="button" style="height: 18px;" class="button disabled one" id="pause">Pause</button>
                            <button type="button" style="height: 18px;" class="button disabled one" id="save">Stop And Save</button>
                            <button type="button" style="height: 18px;" class="button disabled one" id="stop">Discard</button>
                        </div>

                        <div style="padding-right: 21px" class="col-md-9 col-md-offset-15">
                         <%--   <a style="height: 18px; float: right; margin-left: 5px;" href="Cpoe_PreviousVisit.aspx?TID=<%=Request.QueryString["TID"].ToString()+"&PID="+Request.QueryString["PatientID"].ToString()+"&App_ID="+Request.QueryString["App_ID"].ToString()+"&LnxNo="+Request.QueryString["LnxNo"].ToString() %>" target="pagecontent">
                                <img src="../../Images/home.gif" style="height: 21px; border: none" />
                            </a>--%>
                            <button type="button" style="height: 18px; float: right; margin-left: 5px;<%=RoleID=="226"|| RoleID=="424" ?"":"display:none" %>" onclick="UpdateTemperatureRoomOut(document.getElementById('lblAppointmentID').innerHTML)" class="button disabled one" id="btnTempretureOut">Traige Room Out</button>
                            <button type="button" style="height: 18px; float: right; margin-left: 5px;<%=RoleID=="52"?"":"display:none" %>" onclick="$patientFileClose(document.getElementById('lblAppointmentID').innerHTML)" class="button disabled one" id="btnFileClosed">File Close</button>
                            <button type="button" style="height: 18px; float: right; margin-left: 5px;<%=RoleID=="52"?"":"display:none" %>" onclick="$patientOut(document.getElementById('lblAppointmentID').innerHTML)" class="button disabled one" id="btnOut">Out</button>
                            <button type="button" style="height: 18px; float: right;<%=RoleID=="52"?"":"display:none" %>" onclick="$patientHold(document.getElementById('lblAppointmentID').innerHTML)" class="button disabled one" id="btnHold">Hold</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-1">
                    <div class="row col-md-24">
                    <label id="lblAppointmentID" style="display:none"></label>
                         <button type="button" style="" onclick="parent.window.closeIframe()" aria-hidden="true">Back To Search</button>
                    </div>
                    <div class="row col-md-24">
                    </div>
                </div>
            </div>
        </div>
        <div id="divshowimage" class="divshowimage" style="display: none; left: 19.6%; position: fixed; top: 17%; z-index: 9999; box-shadow: 0px 0px 5px #a0a0a0; border: solid 4px #efefef; border-radius: 5px;">
            <img id="imgzoomphoto" src="" alt="" />
        </div>
    </form>
</body>

<script type="text/javascript">
    var transactionID = '<%=Util.GetString(Request.QueryString["TID"])%>';
    var patientID = '<%=Util.GetString(Request.QueryString["PatientID"])%>';
    var doctorID = '<%=Util.GetString(Request.QueryString["DoctorID"])%>';
    var AppID='<%=Util.GetString(Request.QueryString["App_ID"])%>';
    var isViewedPatient =Number('<%=Util.GetString(Request.QueryString["isViwedPatient"])%>');
    var roleid = Number('<%=ViewState["roleID"].ToString() %>');
    $(document).ready(function () {
        $modelUnBlockUI();
         if (roleid == '52') {
            setDefaultSrc();
        }
       // $bindBillDetails(patientID, transactionID);
        $('#divBillDetails').parent().find('.panel-title').click(function () {
            $bindBillDetails(patientID, transactionID);
        });
        $('#divVitalDetails').parent().find('.panel-title').click(function () {
            // $bindVital(transactionID);
        });

        $('#tblMenuMaster').find('a').bind('click', function () {
            //var fullScreenUrls = ['investigation.aspx'];
            //var href = this.href.split('?')[0].split('/')[(this.href.split('?')[0].split('/').length - 1)]
            //if (fullScreenUrls.indexOf(href.toLowerCase()) > -1) {
            //    $('#divViewer').css({ 'padding-right': '0px'});
            //    $('#sidebar-right').hide();
            //   // $('#sidebar-left').hide();
            //}
             $modelBlockUI();
        });

        $('#pagecontent, #sidebar-left, #sidebar-right').height($(window).height() - 92);
        $(window).resize(function () {
            $('#pagecontent, #sidebar-left, #sidebar-right').height($(this).height() - 92);
        });

        $('#leftPanel').slimScroll({ height: '100%', width: '100%', color: 'white' });

        var data = {
            App_ID: $.trim(AppID),
            DoctorID: $.trim(doctorID)
        }

        var roleID = Number('<%=ViewState["roleID"].ToString() %>');

        if (isViewedPatient == 0) {
            if (roleID == 52 || roleID == 323)
                UpdateIn(data);
        }

        if (roleID == 292 && roleID == 293)
            $('#lblAppointmentDate').parent().prev().find('label').text('Date');

        var iframe = document.getElementById("pagecontent");
        iframe.onload = function () {
            $modelUnBlockUI();
        }
    });


    var setDefaultSrc = function () {
        var pageRights = $('#tblMenuMaster a').map(function () { return $(this).attr('href').split('?')[0].toLowerCase() }).get();
        if (pageRights.indexOf('../cpoe/investigation.aspx') > -1) {
            var url = 'Investigation.aspx?TID=<%=Request.QueryString["TID"].ToString()+"&PID="+Request.QueryString["PatientID"].ToString()+"&App_ID="+Request.QueryString["App_ID"].ToString()+"&LnxNo="+Request.QueryString["LnxNo"].ToString() %>';
            $('#pagecontent').attr('src', url);
        }
    }

    var $bindBillDetails = function (patientID, transactionID) {
        serverCall('CPOEFolder.aspx/BindBillDetails', { TransactionID: transactionID, PatientID: patientID }, function (response) {
            if (!String.isNullOrEmpty(response)) {
                var responseData = JSON.parse(response)
                $('#lblDiscount').text(responseData.totalDiscount);
                $('#lblNetAmt').text(responseData.amountBilled);
                $('#lblTaxPer').text(responseData.taxPercent);
                $('#lblTaxAmount').text(responseData.taxAmount);
                $('#lblBillAmount').text(responseData.amountBilled);
                $('#lblNetBillAmount').text(responseData.netBillAmount);
                $('#lblRoundoff').text(responseData.roundOff);
                $('#lblTotalDeduction').text(responseData.totalDeduction);
                $('#lblAdvanceAmount').text(responseData.advance);
                $('#lblRemaining').text(responseData.balanceAmt);
                $('#lblPendingAmount').text(String.isNullOrEmpty(responseData.outStanding) ? 0 : responseData.outStanding);
            }
        });
    }

    var $bindVital = function (transactionID) {
        serverCall('CPOEFolder.aspx/BindVitals', { TransactionID: transactionID }, function (response) {
            if (!String.isNullOrEmpty(response)) {
                var responseData = JSON.parse(response);
                $('#lblTemp').text(responseData[0].Temp);
                $('#lblPulse').text(responseData[0].Pulse);
                $('#lblBp').text(responseData[0].BP);
                $('#lblBS').text(responseData[0].BloodSugar);
                $('#lblResp').text(responseData[0].Resp);
                $('#lblSpO2').text(responseData[0].Oxygen);
            }
        });
    }


    function pendingAmount() {
        // var PID = '<%=Util.GetString(Request.QueryString["PID"])%>';
            window.open('../OPD/OutStandingPrintOut.aspx?PatientID="' + patientID + '"');
        }
        function ShowPatientPhoto(src, value) {
            if (value == 1) {
                $('#divshowimage').show(1000).slideDown(2000);
                $('#imgzoomphoto').attr("src", src);
            }
            if (value == 0)
                $('#divshowimage').hide(1000).slideUp(2000);
        }


        var $patientFileClose = function (appID) {
            modelConfirmation('Patient File Close Confirmation ?', 'Are Your Sure to Close The Patient File for This Visit', 'Yes Close The File', 'No', function (response) {
                if (response) {
                    serverCall('Services/Cpoe_CommonServices.asmx/FileClose', { App_ID: appID }, function (response) {
                        if (response == '1') {
                            modelAlert('File has been Closed', function () {
                                parent.window.searchAppointments();
                                parent.window.closeIframe();
                            });
                        }
                        else {
                            modelAlert('Error...', function () {
                                parent.window.closeIframe();
                            });
                        }
                    });
                }
            });
        }


        var $patientOut = function (appID) {
            var TransactionID = transactionID;
            serverCall('../CPOE/services/PrescribeServices.asmx/CheckTransactionDetail', { TransactionID: TransactionID }, function (response) {
                responsedata = JSON.parse(response);
                if (responsedata.status == 1) {

                    modelConfirmation('Patient Out Confirmation ?', 'Are Your Sure to Out Patient', 'Yes', 'No', function (response) {
                        if (response) {
                            serverCall('Services/Cpoe_CommonServices.asmx/OutPatient', { App_ID: appID }, function (response) {
                                if (response == '1') {
                                    parent.window.searchAppointments();
                                    parent.window.closeIframe();
                                }
                                else {
                                    modelAlert('Error...', function () {
                                        parent.window.closeIframe();
                                    });
                                }
                            });
                        }
                    });
                }
                else {
                    modelAlert('Please Enter Final Diagnosis', function () {
                    });
                }
            });

        }

        var UpdateTemperatureRoomOut = function (appID) {
            modelConfirmation('Patient Out Confirmation ?', 'Are Your Sure to Out Patient', 'Yes', 'No', function (response) {
                if (response) {
                    serverCall('Services/Cpoe_CommonServices.asmx/UpdateTemperatureRoomOut', { App_ID: appID }, function (response) {
                        if (response == '1') {
                            parent.window.searchAppointments();
                            parent.window.closeIframe();
                        }
                        else {
                            modelAlert('Error...', function () {
                                parent.window.closeIframe();
                            });
                        }
                    });
                }
            });
        }
       


        var $patientHold = function (appID) {
            serverCall('../DoctorScreen/Service/SearchAppointment.asmx/Hold', { App_ID: appID }, function (response) {
                parent.window.searchAppointments();
                parent.window.closeIframe();
            });
        }
        function closeIframe() {
            parent.window.searchAppointments();
            parent.window.closeIframe();
        }

        function UpdateIn(data) {
            debugger;
            serverCall('../DoctorScreen/Service/SearchAppointment.asmx/UpdateIn', data, function (response) {
                var responseData = $.trim(response);
               // if (responseData != '1')
                   // modelAlert("Previous Patient Already In");
            });
        }


</script>

        
    <script>
        //Jquery for menu  dropdown 

        /* Loop through all dropdown buttons to toggle between hiding and showing its dropdown content - This allows the user to have multiple dropdowns without any conflict */
        var dropdown = document.getElementsByClassName("dropdown-btn");
        var i;

        for (i = 0; i < dropdown.length; i++) {
            dropdown[i].addEventListener("click", function () {
                this.classList.toggle("active");
                var dropdownContent = this.nextElementSibling;
                if (dropdownContent.style.display === "block") {
                    dropdownContent.style.display = "none";
                } else {
                    dropdownContent.style.display = "block";
                }
            });
        }
        //End Jquery for menu  dropdown 



</script>

</html>
