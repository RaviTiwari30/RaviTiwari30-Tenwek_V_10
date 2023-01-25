<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPFolder.aspx.cs" Inherits="Design_IPD_IPFolder" %>

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
              background:  #0a335e;
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
          
          margin-top:-10px;
          margin-bottom:10px;
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
            <iframe name="pagecontent" id="pagecontent" height="550" src="<%=ViewState["defaultUrl"].ToString()%>?TID=<%= Util.GetString(Request.QueryString["TID"])+"&PID="+Util.GetString(Request.QueryString["PID"])+"&EMGNo="+Util.GetString(Request.QueryString["EMGNo"])+"&LTnxNo="+Util.GetString(Request.QueryString["LTnxNo"])+"&PanelID="+Util.GetString(Request.QueryString["PanelID"]) %>"
                data-scrolling="yes"></iframe>
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
                                <a href='<%#Eval("URL")+"?TID="+Util.GetString(Request.QueryString["TID"])+"&TransactionID="+Util.GetString(Request.QueryString["TID"])+"&PID="+Util.GetString(Request.QueryString["PID"])+"&PatientId="+Util.GetString(Request.QueryString["PID"])+"&EMGNo="+Util.GetString(Request.QueryString["EMGNo"])+"&LTnxNo="+Util.GetString(Request.QueryString["LTnxNo"])+"&App_ID="+Util.GetString(Request.QueryString["App_ID"])+"&notettypeID=&PatientCreationtblid=&LnxNo="+Util.GetString(Request.QueryString["LTnxNo"])+"&PanelID="+Util.GetString(Request.QueryString["PanelID"])+"&RoomID="+Util.GetString(Request.QueryString["RoomID"])  %>' target="pagecontent">
                                    <button type="button" style="width: 100%; text-align: left; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><%#Eval("FileName") %> </button>
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
         
        <div style="overflow-y: auto; overflow-x: hidden; height: 550px;display:none" id="sidebar-right">
            <div id="rightMenu" class="easyui-accordion" style="margin: 1px 1px 1px 1px; background-color: transparent; width: 148px; display: none; box-shadow: 0px 0px 5px #a0a0a0; /*border: solid 4px #efefef; border-radius: 5px; */padding: 1px 1px 1px 1px;">
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
                <div id="divOutStanding" title="OutStanding" style="overflow: auto;">
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
                <button id="btnUpdateCopay" type="button" onclick="ShowPatientPayable()" style="height: 21px; width: 144px;"><strong class="panel-title" style="display: block; font-weight: bold; font-family: Verdana, Arial, sans-serif;">Set Co-Payment</strong></button>
                <button id="btnremark" type="button" onclick="ShowBillingRemark()" class="panel-header accordion-header" style="height: 21px; width: 144px; background-color: #c5c12d; display: none;"><strong class="panel-title" style="display: block; font-weight: bold; font-family: Verdana, Arial, sans-serif;">Billing Remark</strong></button>
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
                        <div class="col-md-3">
                            <label id="lblAge" class="pull-left patientInfo">CASH</label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left bold">Admit On </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <label id="lblAdmitDate" class="pull-left patientInfo"></label>
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
                            <label class="pull-left bold">Panel </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <label id="lblPanel" style="max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" class="pull-left patientInfo"></label>
                        </div>
                         <div class="col-md-2">
                            <label class="pull-left bold">Room No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <label id="lblRoomNo" class="pull-left patientInfo"></label>
                        </div>



                    </div>
                    <div style="margin-top: 1px;" class="row">

                        <div class="col-md-3">
                            <label class="pull-left bold">Discharge On</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <label id="lblDischargeDate" style="max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" class="pull-left patientInfo"></label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left bold">DOB </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <label id="lblDOB" class="pull-left patientInfo"></label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left bold">EMG No </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <label id="lblEMGNo" class="pull-left patientInfo"></label>
                        </div>
                        
                        <div class="col-md-2">
                            <label class="pull-left bold">Pat. Code </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <label id="lblPatientCode" class="pull-left patientInfo"></label>
                        </div>

                        <div class="col-md-1">
                            <button id="btnAllergiesAndDiagnosis" type="button" onclick="$popupAllergiesAndDiagnosis()" class="panel-header accordion-header" style="height: 21px; width: 165px; background-color: #c5c12d; display: none;"><strong class="panel-title" style="font-weight: bold; font-family: Verdana, Arial, sans-serif;" title="Allergies & Diagnosis">Allergies & Diagnosis</strong></button>
                        </div>
                        <div class="col-md-8" style="text-align: right;">
                            <input type="text" id="txtTID" style="display: none" />
                            <input type="text" id="txtLTnxNo" style="display: none" />
                            <input type="text" id="txtStatus" style="display: none" />
                            <input type="text" id="txtRoomId" style="display: none" />

                        </div>

                    </div>



                </div>
                <div class="col-md-1">
                    <button type="button" style="" onclick="parent.window.closeIframe()" aria-hidden="true">Back To Search</button>


                </div>
            </div>
        </div>
        <div id="divshowimage" class="divshowimage" style="display: none; left: 19.6%; position: fixed; top: 17%; z-index: 9999; box-shadow: 0px 0px 5px #a0a0a0; border: solid 4px #efefef; border-radius: 5px;">
            <img id="imgzoomphoto" src="" alt="" />
        </div>



        <div id="divshowRemarkPopUp" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divshowRemarkPopUp" aria-hidden="true">&times;</button>
                        <b class="modal-title">Billing Remarks</b>
                    </div>
                    <div class="modal-body">
                        <div id="divshowRemark" class="divshowRemark" style="width: 500px; height: auto">
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" data-dismiss="divshowRemarkPopUp">Close</button>

                    </div>
                </div>
            </div>
        </div>

        <div id="dvSetCoPaymentPopup" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="width: 920px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="dvSetCoPaymentPopup" aria-hidden="true">&times;</button>
                        <b class="modal-title">Set Co-Payment</b>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">
                                    Bill Amount
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <label id="lblTotalNetBillAmount" class="accordionlabel"></label>
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">
                                    Non-Payable
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <label id="lblPatientNonPayable" class="accordionlabel"></label>
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">
                                    Current Co-Payment
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <label id="lblCoPayment" class="accordionlabel"></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">
                                    Co-Payment(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <input type="text" id="txtCoPayPer" onkeyup="NewPaybleAmount()" onlynumber="5" decimalplace="2" max-value="100" runat="server" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">
                                    New Co-Payment
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <label id="lblCoPaymentNew" class="accordionlabel"></label>
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">
                                    Total Patient Payble
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <label id="lblTotalPatientPayble" class="accordionlabel"></label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" onclick="confirmCoPaymentChange()" id="btnSaveCoPay">Save</button>
                        <button type="button" onclick="confirmCoPaymentRevert()" id="btnRevertCoPay">Revert Last Co-Payment</button>
                        <button type="button" data-dismiss="dvSetCoPaymentPopup">Close</button>

                    </div>
                </div>
            </div>
        </div>
           <div id="dvAllergiesAndDiagnosis" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 40%;">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="closeAllergiesAndDiagnosisModel()" aria-hidden="true">×</button>
                        <h4 class="modal-title">Patient Allergies & Diagnosis</h4>
                    </div>
                    <div style="max-height: 200px; overflow:auto;" class="modal-body">
                        <div id="dvAllergiesAndDiagnosisData"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" onclick="closeAllergiesAndDiagnosisModel()">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
     <script id="tb_AllergiesAndDiagnosispopup" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdAllergiesAndDiagnosis" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="TrHead">
                <th class="GridViewHeaderStyle" scope="col" >S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Type</th>
                <th class="GridViewHeaderStyle" scope="col" >Value</th>
            </tr>
                </thead><tbody>
        <#       
        var dataLength=AllergiesAndDiagnosis.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = AllergiesAndDiagnosis[j];
        #>
               <tr id="TrBody" >        
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.EntryDate #></td>
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.DataType #></td>
                    <td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.DataValues #></td>
               </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>
<script type="text/javascript">
    var transactionID = '<%=Util.GetString(Request.QueryString["TID"])%>';
    var patientID = '<%=Util.GetString(Request.QueryString["PID"])%>';
    $(document).ready(function () {

        $IsShowAllergiesAndDiagnosisButton(patientID);
        $('#tblMenuMaster').find('a').bind('click', function () {
            $modelBlockUI();
        });
        $('#pagecontent, #sidebar-left, #sidebar-right').height($(window).height() - 92);
        $(window).resize(function () {
            $('#pagecontent, #sidebar-left, #sidebar-right').height($(this).height() - 92);
        });
        $('#leftPanel').slimScroll({ height: '100%', width: '100%', color: 'white' });
        var iframe = document.getElementById("pagecontent");
        iframe.onload = function () {
            $modelUnBlockUI();
        }
    });


    function ShowPatientPhoto(src, value) {
        if (value == 1) {
            $('#divshowimage').show(1000).slideDown(2000);
            $('#imgzoomphoto').attr("src", src);
        }
        if (value == 0)
            $('#divshowimage').hide(1000).slideUp(2000);
    }
    var blink = function () {
        $('#btnremark').animate({
            opacity: '0'
        }, function () {
            $(this).animate({
                opacity: '4'
            }, blink);
        });
    }


    var $IsShowAllergiesAndDiagnosisButton = function (patientID) {
        debugger;
        $("#btnAllergiesAndDiagnosis").hide();
        serverCall('IPFolder.aspx/GetAllergiesAndDiagnosis', { patientID: patientID }, function (response) {
            AllergiesAndDiagnosis = JSON.parse(response);
            if (AllergiesAndDiagnosis.length > 0) {
                $("#btnAllergiesAndDiagnosis").show();
            }
        });
    }
    var $popupAllergiesAndDiagnosis = function () {
        var patientID = '<%=Util.GetString(Request.QueryString["PID"])%>';;
        serverCall('IPFolder.aspx/GetAllergiesAndDiagnosis', { patientID: patientID }, function (response) {
            AllergiesAndDiagnosis = JSON.parse(response);
            if (AllergiesAndDiagnosis.length > 0) {
                var message = $('#tb_AllergiesAndDiagnosispopup').parseTemplate(AllergiesAndDiagnosis);
                $('#dvAllergiesAndDiagnosisData').html(message);
                $('#dvAllergiesAndDiagnosis').showModel();
            }

        });
    }
    var closeAllergiesAndDiagnosisModel = function () {
        $('#dvAllergiesAndDiagnosis').closeModel();
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
