<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleCollectionLab.aspx.cs" Inherits="Design_Lab_SampleCollectionLab" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Lab/Popup.ascx" TagName="PopUp" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />
        <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <script type="text/javascript">
         var $PatientHistory = function (pid) {
            //var TID = $(rowID).closest('tr').find('#lblTransactionID').text();

            //var href = "../CPOE/Investigation.aspx?PID=" + PID + "&TID=" + TID + "";
             var href = "../CPOE/Investigation.aspx?PID=" + pid+"";
             
            showuploadbox(href, 1400, 1360, '100%', '100%');
        }
         function showuploadbox(href, maxh, maxw, w, h) {
             $.fancybox({
                 maxWidth: maxw,
                 maxHeight: maxh,
                 fitToView: false,
                 width: w,
                 href: href,
                 height: h,
                 autoSize: false,
                 closeClick: false,
                 openEffect: 'none',
                 closeEffect: 'none',
                 'type': 'iframe'
             });
         }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Sample Collection</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" ClientIDMode="Static"
                                CssClass="ItDoseRadiobuttonlist" Font-Bold="True" Font-Size="Small"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Text="ALL" Value="0"></asp:ListItem>
                                <asp:ListItem Text="OPD" Value="1"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Emergency" Value="3"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPName" autocomplete="off" data-title="Enter Patient Name" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Barcode No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtLabNo" autocomplete="off" data-title="Enter Lab No." />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtUHID" autocomplete="off" data-title="Enter UHID" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sample Collected
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSampleStatus">
                                <option value="N" selected="selected">Sample Not Colleted</option>
                                <option value="S">Collected</option>
                                <option value="Y">Received</option>
                                <option value="R">Rejected</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDepartment">
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctor">
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPanel">
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Type Test
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPatientType">
                                <option value="">ALL</option>
                                <option value="1">Urgent</option>
                                <option value="0">Normal</option>
                            </select>
                        </div>
                        <div class="col-md-3" style="display: none">
                            <label class="pull-left">
                                Center Access
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display: none">
                            <select id="ddlCenterAccess"></select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room Name
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <select id="ddlRoomName"></select>
                        </div>
                        <div id="divRoom">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Floor
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlFloor" title="Select Floor" onchange="bindRoomType()"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Ward 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="cmbRoom" title="Select Ward Type"></select>
                            </div>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-24" style="text-align: center">
                            <label style="width: 20px; height: 20px;float: left;margin-left: -70px;" class="blink-two">
                                <span data-title="Patient Having Pending Amount" style="cursor:pointer;color:white;background-color:Red;font-size:18px;padding-left:8px;padding-right:8px;border-radius:20px;">P</span> 
                            </label>
                            <b style="margin-top: 3px; margin-left: -36px; float: left">Pending Amount</b>

                             <label style="width: 20px; height: 20px; margin-left: 2px; float: left; background-color: #1af5ffab;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: 2px; float: left">Sample To Recollect</b>

                            <input type="button" id="btnsearch" value="Search" onclick="SearchPatientDetails()" />
                        </div>
                    </div>
                    <div class="row">


                        <div class="col-md-24">
                            <%--<button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:#CC99FF;" class="circle"></button>--%>
                            <label style="width: 20px; height: 20px; margin-left: -70px; float: left; background-color: ;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: -45px; float: left">OPD</b>
                            <%--<button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:bisque;" class="circle"></button>--%>
                            <label style="width: 20px; height: 20px; margin-left: 2px; float: left; background-color: bisque;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: 2px; float: left">IPD</b>
                            <%--<button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:#FF0000;" class="circle"></button>--%>
                            <label style="width: 20px; height: 20px; margin-left: 2px; float: left; background-color: #FF0000;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: 2px; float: left">Emergency</b>
                            <%--<button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:#ffff00;" class="circle"></button>--%>
                            <label style="width: 20px; height: 20px; margin-left: 2px; float: left; background-color: #ffff00;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: 2px; float: left">Sample Req. Time</b>
                            <label style="width: 20px; height: 20px; margin-left: 2px; float: left; background-color: DarkKhaki;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: 2px; float: left">Sample Req. expired</b>
                              <label style="width: 20px; height: 20px; margin-left: 2px; float: left; background-color: #ec92af;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: 2px; float: left">Pending Req.</b>
                            <label style="width: 20px; height: 20px; margin-left: 2px; float: left; background-color: orange;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: 2px; float: left">Upcoming Req. next 30mins</b>
                            <label style="width: 20px; height: 20px; margin-left: 2px; float: left; background-color: lightseagreen;" class="circle"></label>
                            <b style="margin-top: 5px; margin-left: 2px; float: left">Called Patient  <input type="button" id="btndoctorOrders" value="Ward Sample Coll. List" onclick="DoctorOrders()" /></b>
                                    
                            </div>
                     
                            </div>

                 
                   

                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="SearchFilteres">
            <div class="Purchaseheader">
                Search Option
             &nbsp;&nbsp;
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table width="99%">
                <tr>
                    <td width="40%" valign="top">
                        <div class="Purchaseheader">
                            Patient Detail
                                     <div style="text-align: right; position: relative; min-height: 1px; padding-right: 7.5px; padding-left: 7.5px; float: right;">
                                         <span style="font-weight: bold; color: white;">Total Patient:</span>
                                         <asp:Label ID="lblTotalPatient" ForeColor="White" runat="server" CssClass="ItDoseLblError" />
                                     </div>
                        </div>
                        <div style="width: 100%; max-height: 300px; overflow: auto;">
                            <table style="width: 100%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                                <tr id="paheader">
                                    <th class="GridViewHeaderStyle" scope="col" style="font-size: x-small; width: 30px">S.No.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="display: none">View</th>
                                    <td class="GridViewHeaderStyle" style="width: 25px; font-size: x-small"></td>
                                    <td class="GridViewHeaderStyle" style="width: 25px; font-size: x-small">DOC</td>
                                    <td class="GridViewHeaderStyle" style="width: 25px; font-size: x-small">Doctor</td>
                                    <th class="GridViewHeaderStyle" scope="col" style="font-size: x-small; width: 90px">Patient Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="font-size: x-small; width: 77px">UHID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 25px; font-size: x-small">Age/Gender</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="font-size: x-small; width: 56px">Order Date</th>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td width="66%" valign="top">
                        <div class="Purchaseheader" style="width: 101.5%">
                            <div class="row">
                                <div class="col-md-5">Sample Detail</div>
                                <div class="col-md-3">
                                    <label class="pull-left">PName</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-7"><span id="spnCollectionPatientName"></span></div>
                                <div class="col-md-3">
                                    <label class="pull-left">BedNo</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-6"><span id="spnBedNo"></span></div>
                            </div>

                            <div style="text-align: right; position: relative; min-height: 1px; padding-right: 7.5px; padding-left: 7.5px; float: right;">
                                <span style="font-weight: bold; color: white;">Total Test:</span>
                                <asp:Label ID="Label1" runat="server" ForeColor="White" />
                                <span id="spnledgerno" style="display: none"></span>
                            </div>

                        </div>
                        <div>
                            <div style="width: 101.5%; max-height: 300px; overflow: auto;">
                                <table style="width: 100%" cellspacing="0" id="tbsample" class="GridViewStyle">
                                    <tr id="saheader">
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Sample Type</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px; display: none">Ward</th> 
                                       <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Test Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Barcode No.<br />
                                            <input type="text" id="txtSINNo" name="mybarocde" style="width: 100px; display: none" placeholder="Barcode No." onkeyup="setbarcodetoall(this)" /></th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">SC Withdraw Req Date</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">SC Actual Withdraw Date</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Devation Time</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">
                                            <input type="checkbox" onclick="call()" id="hd" />
                                        </th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">Vial Color</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">#</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">Re-Print</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">Reject</th>
                                    </tr>
                                </table>

                            </div>
                            <div class="row" style="text-align: right; width: 100.6%;">
                                <input type="button" value="Call" id="btnCall" style="display: none"  onclick="CallPatient()" />
                                <input type="button" value="Un-Call" id="btnUnCall" style="display: none"  onclick="UnCallPatient()" />
                                <input type="button" value="Collect" id="btnsamplecollect" style="display: none" onclick="SampleCollection()" />
                            </div>
                        </div>
                    </td>
                </tr>
            </table>


        </div>
    </div>
    <div id="RejectSample" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 500px; max-width: 80%">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closeRejectSample()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Reject Sample</h4>
                    <span id="spnTestID" style="display: none"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-8">
                            <label class="pull-left">Reject Reason    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-15">
                            <input type="text" id="txtRejectReason" />
                        </div>
                    </div>

                    <div style="text-align: center" class="row">
                        <button type="button" onclick="$rejectsample($('#txtRejectReason').val(),$('#spnTestID').text())">Reject</button>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
    <div id="DetailPopup" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 500px; max-width: 80%">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closeDetailPopup()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Sample Details</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-22">
                            <label class="pull-left">
                                <b><span id="spnname"></span></b>
                            </label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-22">
                            <b><span id="sampledate"></span></b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-22">
                            <b><span id="spnReason"></span></b>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
    <div id="divSReqpatientServicePerModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 50%">
                <div class="modal-header">
                    <b class="modal-title">
                        <label style="margin-top: -10px; width: 25px; height: 25px; margin-left: 5px; float: left; background-color: DarkKhaki;" class="circle"></label>
                        <b style="margin-top: -10px; margin-left: 5px; float: left">Sample request expired</b>
                        <label style="margin-top: -10px; width: 25px; height: 25px; margin-left: 5px; float: left; background-color: orange;" class="circle"></label>
                        <b style="margin-top: -10px; margin-left: 5px; float: left">Upcoming requests next 30 mins</b>
                    </b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div id="divList" style="max-height: 163px; max-width: 643px; overflow-x: auto;">
                            <table class="FixedHeader" id="tbSRequestpatient" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">Sr No</th>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">PatientName</th>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">UHID</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeSReqpatientServicePerModel()">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="divDoctorOrders" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 50%">
                <div class="modal-header">
                    <b class="modal-title">Sample Requisition Report
                    </b>

                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <input type="text" class="datepicker required" autocomplete="off" id="txtdate" />
                        </div>
                        <div class="col-md-4">
                          <label class="pull-left">From Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="txtFromTime" class="timepicker required" autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> Ward</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlLocation">
                            </select>
                        </div>                       
                    </div>

                    <div class="row">
                         <div class="col-md-4">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-4">
                            <input type="text" class="datepicker required" autocomplete="off" id="txtToDate" />
                        </div>
                         <div class="col-md-4">
                            <label class="pull-left">To Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="txtToTime" class="timepicker required" autocomplete="off" />
                        </div>                      
                    </div>

                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <input type="button" id="btnDoctorOrderReport" class="buItDoseButton" value="Report" onclick="getDoctorOrderreort();" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="divCloseoctorOrders()">Close</button>
                </div>
            </div>
        </div> 
    </div>
    <uc1:PopUp id="popupctrl" runat="server" />    
    <script type="text/javascript">
        function showme(Name, Detail, reason) {
            if (reason != "") {
                $('#spnReason').text('Sample Reject Reason : ' + reason);
            }
            $('#spnname').text('Name of Person : ' + Name);
            $('#sampledate').text('Date & Time : ' + Detail);
            $('#DetailPopup').showModel();
        }
        $closeDetailPopup = function () {
            $('#spnReason').text('');
            $('#spnname').text('');
            $('#sampledate').text('');
            $('#DetailPopup').hideModel();
        }
        function $rejectsample(RejectReason, TestID) {
            if (TestID == "") {
                modelAlert("Kindly Refresh The Page");
                return;
            }
            if (RejectReason == "") {
                modelAlert("Please Enter The Reject Reason");
                return;
            }
            serverCall('../Lab/SampleCollectionLab.aspx/SampleRejection', { RejectReason: RejectReason, TestID: TestID }, function (response) {
                if (response == "1") {
                   
                    modelAlert("Sample Reject Successfully", function () {
                        $closeRejectSample();
                        SearchPatientDetails();
                    });
                    return;
                }
                else {
                    $closeRejectSample();
                    modelAlert(response);
                    return;
                }
            });
        }
        function $showRejectSample(TestID) {
            $('#spnTestID').text(TestID);
            $('#RejectSample').showModel();
        }

        $closeRejectSample = function () {
            $('#txtRejectReason').val('');
            $('#spnTestID').text('');
            $('#RejectSample').hideModel();
        }
        $(function () {
            //$('input').keyup(function () {
            //    //if (event.keyCode == 13)
            //    //    if ($(this).val() != "")
            //            SearchPatientDetails();
            //});
            $bindDepartment(function (selectedDepartment) {
                $bindDoctor(selectedDepartment, function () {
                    $bindPanel(function () {
                        $bindCenter(function () { });
                        $bindCollectionRoom(function () { });
                        BindFloor();
                        bindRoomType();
                    });
                });
            });

            $bindddlLocation(function () { });
        });
        var $bindDepartment = function (callback) {
            var $ddlDepartment = $('#ddlDepartment');
            serverCall('../common/CommonService.asmx/bindDepartment', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($ddlDepartment.find('option:selected').text());
            });
        }
        var $bindDoctor = function (department, callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Doctor_ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($ddlDoctor.val());
            });
        }
        $bindPanel = function (callback) {
            serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
                var $ddlPanel = $('#ddlPanel');
                $ddlPanel.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true, selectedValue: 'All' });
                callback($ddlPanel.val());
            });
        }
        $bindCenter = function (callback) {
            serverCall('../Lab/SampleCollectionLab.aspx/bindCenter', {}, function (response) {
                var $ddlCenterAccess = $('#ddlCenterAccess');
                $ddlCenterAccess.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                callback($ddlCenterAccess.val());
            });
        }

        $bindCollectionRoom = function (callback) {
            serverCall('../Lab/SampleCollectionLab.aspx/BindCollectionRoom', {}, function (response) {
                var $ddlRoomName = $('#ddlRoomName');
                $ddlRoomName.bindDropDown({ data: JSON.parse(response), valueField: 'id', textField: 'roomName', isSearchAble: true });
                callback($ddlRoomName.val());
            });
        }

        var $bindddlLocation = function (callback) {
            var $ddlDepartment = $('#ddlLocation');
            serverCall('../Lab/SampleCollectionLab.aspx/bindLocation', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($ddlDepartment.find('option:selected').text());
            });
        }

        if ($('#ddlFloor').val() == "0") {
            if (dataFloor.length > 0) {
                $.each(dataFloor, function (index, valueFloor) {
                    if (FloorID == "")
                        FloorID = "'" + valueFloor + "'";
                    else
                        FloorID += ",'" + valueFloor + "'";
                });
            }
        }
        else {
            FloorID = $('#ddlFloor').val();
        }

        if ($('#cmbRoom').val() == "0") {
            if (dataRoom.length > 0) {
                $.each(dataRoom, function (index, valueRoom) {
                    if (RoomID == "")
                        RoomID = "'" + valueRoom + "'";
                    else
                        RoomID += ",'" + valueRoom + "'";
                });
            }
        }
        else {
            RoomID = "'" + $('#cmbRoom').val() + "'";
        }

        var dataRoom = [];
        var dataFloor = [];       

        $('input[id*=rdbLabType]').click(function () {
            if ($('input:radio[id*=rdbLabType]:checked').val() == "0")               
                 $("#divRoom").show();
            else if ($('input:radio[id*=rdbLabType]:checked').val() == "2")              
                $("#divRoom").show();
             else            
                $("#divRoom").hide();
        });      

        function BindFloor() {
            var ddlFloor = jQuery("#ddlFloor");
            jQuery("#ddlFloor option").remove();

            var Floor = {
                type: "POST",
                url: "../Lab/SampleCollectionLab.aspx/BindFloor",
                data: '{ }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    Floor = jQuery.parseJSON(result.d);
                    if (Floor != null) {
                        ddlFloor.chosen('destroy');
                        ddlFloor.append(jQuery("<option></option>").val("0").html("ALL"));
                        if (Floor.length == 0) {
                            ddlFloor.append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {

                            for (i = 0; i < Floor.length; i++) {
                                ddlFloor.append(jQuery("<option></option>").val(Floor[i].ID).html(Floor[i].NAME))
                                dataFloor.push(Floor[i].ID);
                                if (Floor.length == 1)
                                    ddlFloor.val(Floor[i].ID).attr('disabled', 'disabled');
                            }
                        }
                    }

                    ddlFloor.chosen();
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            };
            jQuery.ajax(Floor);
        }

        function bindRoomType() {
            jQuery("#cmbRoom option").remove();
            jQuery.ajax({
                url: "../Lab/SampleCollectionLab.aspx/BindRoomType",
                data: '{FloorID:"' + $('#ddlFloor').val() + '",isAttenderRoom:"' + 0 + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    RoomData = jQuery.parseJSON(result.d);
                    $("#cmbRoom").append($("<option></option>").val("0").html("ALL"));
                    if (RoomData!="" && RoomData!=null)
                        {
                        for (i = 0; i < RoomData.length; i++) {
                            $("#cmbRoom").append($("<option></option>").val(RoomData[i].IPDCaseTypeID).html(RoomData[i].Name)).chosen('destroy').chosen();
                            dataRoom.push(RoomData[i].IPDCaseTypeID);
                            if (RoomData.length == 1)
                                $("#cmbRoom").val(RoomData[i].IPDCaseTypeID).attr('disabled', 'disabled');
                        }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function DoctorOrders() {
            $('#divDoctorOrders').showModel();
        }
        var divCloseoctorOrders = function () {
            $('#divDoctorOrders').closeModel();
        }

        $('.datepicker').datepicker({
            minDate: -30,
            maxDate: 0, // 1
            dateFormat: 'yy-mm-dd',
        }).datepicker("setDate", 'now');


        //var d = new Date(1980, 2, 2);
        //$('.datepicker').datepicker({
        //    changeMonth: true,
        //    changeYear: true,
        //    defaultDate: d,
        //    yearRange: '1970:1992',
        //    dateFormat: 'yy-mm-dd',
        //    monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        //    dayNamesMin: ['Mon', 'Tue', 'Wed', 'Thu', '&#268;et', 'Pet', 'Sub']
        //});
        $('#txtFromTime').timepicker({
            timeFormat: 'h:mm p',
            interval: 1,
            minTime: '00:00',
            maxTime: '11:59pm',
            defaultTime: '00:00', //new Date(),
            startTime: '00:00',
            dynamic: false,
            dropdown: true,
            scrollbar: true
        });

        $('#txtToTime').timepicker({
            timeFormat: 'h:mm p',
            interval: 1,
            minTime: '00:00',
            maxTime: '11:59pm',
            // defaultTime: new Date(new Date().getTime() + 6 * 3600 * 1000),
            defaultTime: new Date(),
            startTime: '00:00',
            dynamic: false,
            dropdown: true,
            scrollbar: true
        });


        function SearchPatientDetails() {
            $('#tb_ItemList tr').slice(1).remove();
            $('#tbsample tr').slice(1).remove();
            pcount = 0;
            var searchdata = getsearchdata();
            serverCall('SampleCollectionLab.aspx/SearchSampleCollection', { searchdata: searchdata }, function (response) {
                if (response != "") {
                    TestData = JSON.parse(response);
                    if (TestData.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').html('0');
                        $('#<%=Label1.ClientID%>').html('0');
                        modelAlert("No Record Found");
                        return;
                    }
                    else {
                        $('#tb_ItemList tr').slice(1).remove();
                        for (var i = 0; i <= TestData.length - 1; i++) {
                            pcount = parseInt(pcount) + 1;
                            $('#<%=lblTotalPatient.ClientID%>').text(pcount);

                            if (TestData[i].IsRecollect == "1") { 
                                TestData[i].rowcolour = "#1af5ffab";
                            }

                            if (TestData[i].IsPaymentApproved ==1) {
                                var mydata = "<tr id='" + TestData[i].LedgerTransactionNo + "'  style='background-color:" + TestData[i].rowcolour + ";cursor:pointer' onclick='showbarcodedata(\"" + TestData[i].LedgerTransactionNo + "\")' >";
                            }
                            else
                                var mydata = "<tr id='" + TestData[i].LedgerTransactionNo + "'  style='background-color:" + TestData[i].rowcolour + ";' >";
                            mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b><img alt="" src="../../Images/home.gif" onclick="$PatientHistory(' + TestData[i].PatientID + ');" id="img1" title="Patient History" /></b></td>'

                            if (TestData[i].IsPaymentApproved == 1) {
                                mydata += '<td class="GridViewLabItemStyle"><img src="../../Images/attachment.png" style="cursor:pointer;" onclick="openpopup6(\'' + TestData[i].LedgerTransactionNo + '\')"/> </td>';
                            }
                            else
                                mydata += '<td class="GridViewLabItemStyle blink-two"><span data-title="' + TestData[i].PendingApprovalMessage + '" style="cursor:pointer;color:white;background-color:Red;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;">P</span> </td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b>' + TestData[i].PdoctorName + '</b></td>'
                            mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b>' + TestData[i].PName + '</b></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small; ' + (TestData[i].SReColorcode == '1' ? 'background-color: yellow;' : TestData[i].SReColorcode == '2' ? 'background-color: orange;' : TestData[i].SReColorcode == '3' ? 'background-color: DarkKhaki;' : TestData[i].SReColorcode == '4' ? 'background-color: #ec92af;' : '') + ' "   ><b>' + TestData[i].PatientID + '</b></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b>' + TestData[i].Age + '</b></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small">' + TestData[i].BillDate + '</td>';
                            mydata += "</tr>";
                            $('#tb_ItemList').append(mydata);
                            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                        }

                            checkSReqpatient();
                        }
                    }
                    else { modelAlert("No Record Found"); }
                });
            }

            function checkSReqpatient() {

            serverCall('SampleCollectionLab.aspx/searchSReqPatient', { fromDate: $('#FrmDate').val(), toDate: $('#ToDate').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData != "") {
                    $('#divSReqpatientServicePerModel').showModel();
                    $('#tbSRequestpatient tbody ').empty();
                    if (responseData.length > 0) {
                        for (var i = 0; i < responseData.length; i++) {
                            var j = $('#tbSRequestpatient tbody tr').length + 1;
                            var row = "<tr id='" + responseData[i].LedgerTransactionNo + "' onclick='showbarcodedata(\"" + responseData[i].LedgerTransactionNo + "\")'>";
                            row += '<td class="GridViewLabItemStyle" style="text-align: center;' + (responseData[i].colorid == '3' ? 'background-color: DarkKhaki;' : responseData[i].colorid == '2' ? 'background-color: orange;' : responseData[i].colorid == '4' ? 'background-color: #ec92af;' : 'background-color: DarkKhaki;') + '">' + j + '</td>';

                            row += '<td id="tdSReqpatientname" class="GridViewLabItemStyle" style="text-align: center;' + (responseData[i].colorid == '3' ? 'background-color: DarkKhaki;' : responseData[i].colorid == '2' ? 'background-color: orange;' : responseData[i].colorid == '4' ? 'background-color: #ec92af;' : 'background-color: DarkKhaki;') + '">' + responseData[i].Pname + '</td>';
                            row += '<td id="tdSReqpatientuhid" class="GridViewLabItemStyle" style="text-align: center;' + (responseData[i].colorid == '3' ? 'background-color: DarkKhaki;' : responseData[i].colorid == '2' ? 'background-color: orange;' : responseData[i].colorid == '4' ? 'background-color: #ec92af;' : 'background-color: DarkKhaki;') + '">' + responseData[i].PatientID + '</td>';
                            row += '</tr>'
                            $('#tbSRequestpatient tbody').append(row);
                        }
                    }

                    }

                });
            }
            var closeSReqpatientServicePerModel = function () {
                $('#divSReqpatientServicePerModel').closeModel();
            }
            function openpopup6(LedgerTransactionNo) { 
                fancypopuplst(LedgerTransactionNo);
            }
            function getsearchdata() {
                var dataPLO = new Array();
                dataPLO[0] = $('#ddlCenterAccess').val();
                dataPLO[1] = $('#ddlSampleStatus').val();
                dataPLO[2] = $('input:radio[id*=rdbLabType]:checked').val();
                dataPLO[3] = $('#txtLabNo').val();
                dataPLO[4] = $('#txtPName').val();
                dataPLO[5] = $('#txtUHID').val();
                dataPLO[6] = $('#ddlPatientType').val();
                dataPLO[7] = $('#ddlDepartment').val();
                dataPLO[8] = $('#ddlDoctor').val();
                dataPLO[9] = $('#ddlPanel').val();
                dataPLO[10] = $('#FrmDate').val();
                dataPLO[11] = $('#ToDate').val();
                dataPLO[12] = $('#cmbRoom').val();
                return dataPLO;
            }
            var samplecount = 0;
            function showbarcodedata(LedgerTransactionNo) {
                $('#divSReqpatientServicePerModel').closeModel();

                $('#tbsample tr').slice(1).remove();
                samplecount = 0;
                serverCall('SampleCollectionLab.aspx/SearchInvestigation', { LedgerTransactionNo: LedgerTransactionNo }, function (response) {

                    if (response != "") {
                        TestData1 = JSON.parse(response);
                        if (TestData1.length == 0) {
                            $('#<%=Label1.ClientID%>').html('0');
                            samplecount = 0;
                            return;
                        }
                        else {

                            if (TestData1[0].CallStatus == 0) {
                                $('#btnUnCall').attr('disabled', 'disabled');
                                $('#btnsamplecollect').attr('disabled', 'disabled');
                                $('#btnCall').attr('disabled', false);
                            }
                            else if (TestData1[0].CallStatus == 1) {
                                $('#btnCall').attr('disabled', true);
                                $('#btnUnCall').attr('disabled', false);
                                $('#btnsamplecollect').attr('disabled', false);
                            }
                            else if (TestData1[0].CallStatus == 2) {
                                $('#btnUnCall').attr('disabled', false);
                                $('#btnsamplecollect').attr('disabled', true);
                                $('#btnCall').attr('disabled', false);
                            }
                            else if (TestData1[0].CallStatus == 3) {
                                $('#btnUnCall').attr('disabled', 'disabled');
                                $('#btnsamplecollect').attr('disabled',false);
                                $('#btnCall').attr('disabled', true);
                            }

                            $('#spnledgerno').text('');
                            $('#spnCollectionPatientName').text(TestData1[0].PName);
                            $('#spnBedNo').text(TestData1[0].bed);
                            
                            $('#spnledgerno').text(LedgerTransactionNo);
                            for (var i = 0; i <= TestData1.length - 1; i++) {

                                if (TestData1[i].IsRecollect=="1") {
                                    TestData1[i].rowcolor = "#1af5ffab";
                                }
                                samplecount = parseInt(samplecount) + 1;
                                $('#<%=Label1.ClientID%>').text(samplecount);
                                var mydata = "<tr id='" + TestData1[i].TestID + "'  style='background-color:" + TestData1[i].rowcolor + ";'>";
                                mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">';
                                if (TestData1[i].IsSampleCollected == "N") {
                                    if (TestData1[i].reporttype == "7") {
                                        mydata += '<select id="ddlDoctorPath" style="width:50px;background-color:lightgreen;"">';
                                        if (TestData1[i].doctorlist.split('$').length > 1) {
                                            mydata += '<option value="0"></option>';
                                        }
                                        for (var c = 0; c <= TestData1[i].doctorlist.split('$').length - 1; c++) {

                                            mydata += '<option value="' + TestData1[i].doctorlist.split('$')[c].split('|')[0] + '">' + TestData1[i].doctorlist.split('$')[c].split('|')[1] + '</option>';
                                        }
                                        mydata += '</select><br>';

                                        if (TestData1[i].SampleID.length > 0) {
                                            mydata += '<input id="txtspecimentype" onkeypress="return blockSpecialChar(event)"  value="' + TestData1[i].SampleID.split('|')[0].split('^')[1] + '" type="text" placeholder="Enter Specimen Type" style="width:140px;background-color:lightblue;"/>';
                                        }
                                        else
                                            mydata += '<input id="txtspecimentype" onkeypress="return blockSpecialChar(event)" value=""  type="text" placeholder="Enter Specimen Type" style="width:140px;background-color:lightblue;"/>';
                                        mydata += '<br/><strong>No of Container:</strong>&nbsp;&nbsp;<select id="ddlnoofsp"><option>0</option>';
                                        mydata += '<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>';
                                        mydata += '<option>6</option><option>7</option><option>8</option><option>9</option></select>';

                                        mydata += '<br/><strong>No of Slides:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofsli">';
                                        mydata += '<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>';
                                        mydata += '<option>6</option><option>7</option><option>8</option><option>9</option></select>';

                                        mydata += '<br/><strong>No of Block:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofblock">';
                                        mydata += '<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>';
                                        mydata += '<option>6</option><option>7</option><option>8</option><option>9</option></select>';
                                        mydata += '<span id="tdss" style="display:none">' + TestData1[i].SampleID.split('|')[0].split('^')[0] + '</span>';
                                    }
                                    else {
                                        mydata += '<select id="sampletypes" style="width:140px;background-color:pink;" onchange="setclass(this)">';
                                        if (TestData1[i].SampleTypes.split('$').length > 1) {
                                            mydata += '<option value="0"></option>';
                                        }
                                        for (var c = 0; c <= TestData1[i].SampleTypes.split('$').length - 1; c++) {
                                            if (TestData1[i].SampleID.split('^')[0] == TestData1[i].SampleTypes.split('$')[c].split('|')[0])
                                                mydata += '<option selected="selected" value="' + TestData1[i].SampleTypes.split('$')[c].split('|')[0] + '">' + TestData1[i].SampleTypes.split('$')[c].split('|')[1] + '</option>';
                                            else
                                                mydata += '<option value="' + TestData1[i].SampleTypes.split('$')[c].split('|')[0] + '">' + TestData1[i].SampleTypes.split('$')[c].split('|')[1] + '</option>';
                                        }
                                        mydata += '</select>';
                                        mydata += '<span id="tdss" style="display:none">' + TestData1[i].SampleID.split('|')[0].split('^')[0] + '</span>';
                                    }
                                }
                                //else
                                //mydata += '<span id="tdss">' + TestData1[i].SampleID.split('|')[1] + '</span>';
                                mydata += '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small; display: none;" ><b>' + TestData1[i].RoomType + '</b></td>';
                         
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b>' + TestData1[i].name + '</b></td>';
                                mydata += '<td class="GridViewLabItemStyle" >';
                                if (TestData1[i].IsSampleCollected == "N") {
                                    if (TestData1[i].PrePrintedBarcode == "1") {
                                        mydata += '<input type="textbox" name="mybarocde" onkeyup="samebarcode(this)" id="tdsinno" ';
                                        if (TestData1[i].SampleTypes.split('$').length > 1) {
                                            mydata += 'class="sample_0" ';
                                        }
                                        else {
                                            mydata += 'class="sample_' + TestData1[i].SampleTypes.split('|')[0] + '" ';
                                        }
                                        mydata += 'placeholder="Barcode No." style="width:100px;"/>';
                                    }
                                    else {
                                        mydata += '<span id="tdsinno" name="mybarocde" onkeyup="samebarcode(this)" ';
                                        if (TestData1[i].SampleTypes.split('$').length > 1) {
                                            mydata += 'class="sample_0" ';
                                        }
                                        else {
                                            mydata += 'class="sample_' + TestData1[i].SampleTypes.split('|')[0] + '" ';
                                        }
                                        mydata += '>' + TestData1[i].BarcodeNo + '</span> ';
                                    }
                                }
                                else {

                                    mydata += '<span id="tdsinno" name="mybarocde" onkeyup="samebarcode(this)" ';
                                    if (TestData1[i].SampleTypes.split('$').length > 1) {
                                        mydata += 'class="sample_0" ';
                                    }
                                    else {
                                        mydata += 'class="sample_' + TestData1[i].SampleTypes.split('|')[0] + '" ';
                                    }
                                    mydata += '>' + TestData1[i].BarcodeNo + '</span> ';
                                }

                                mydata += '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b><span id="spnScRequestdatetime">' + TestData1[i].Samplerequestdate + '</span></b></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small" ><b><span id="spnScRequestdate"> ' + TestData1[i].Acutalwithdrawdate + '</span></b></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b>' + TestData1[i].DevationTime + '</b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="con" style="display:none;">' + TestData1[i].IsSampleCollected + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"> ';
                                if (TestData1[i].IsSampleCollected == "N" || TestData1[i].IsSampleCollected == "S" || TestData1[i].IsSampleCollected == "R") {
                                    mydata += '<input type="checkbox" ';
                                    if (TestData1[i].IsSampleCollected == "N") {
                                        mydata += 'checked="checked" ';
                                    }
                                    else
                                        mydata += 'disabled="disabled" ';
                                    mydata += ' id="mmchk"/>';
                                }
                                mydata += '</td>';
                                if (TestData1[i].colorcode.split('^')[1] != "")
                                    mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"><span style="cursor:pointer;color:white;background-color:' + TestData1[i].colorcode.split('^')[1] + ';font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" data-title="Vial Color">' + TestData1[i].colorcode.split('^')[0] + '</span></td>';
                                else
                                    mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"><span style="cursor:pointer;color:white;background-color:green;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;fore-color:red" data-title="Vial Color">' + TestData1[i].colorcode.split('^')[0] + '</span></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="text-align:center;" id="mmtd"> ';

                                if (TestData1[i].IsSampleCollected == "N") {
                                    mydata += '';
                                }
                                else if (TestData1[i].IsSampleCollected == "S") {
                                    mydata += '<span style="cursor:pointer; color:white;background-color:green;font-size:14px;padding-left:8px;padding-right:8px;border-radius:20px;" onclick="showme(\'' + TestData1[i].SampleCollector + '\',\'' + TestData1[i].colldate + '\',\'' + TestData1[i].rejectreason + '\')">C</span>';
                                }
                                else if (TestData1[i].IsSampleCollected == "Y") {
                                    mydata += '<span style="cursor:pointer;color:white;background-color:blue;font-size:14px;padding-left:8px;padding-right:8px;border-radius:20px;" onclick="showme(\'' + TestData1[i].SampleReceiver + '\',\'' + TestData1[i].recdate + '\',\'' + TestData1[i].rejectreason + '\')" >Y</span>';
                                }
                                else if (TestData1[i].IsSampleCollected == "R") {
                                    mydata += '<span style="cursor:pointer;color:white;background-color:red;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;" onclick="showme(\'' + TestData1[i].rejectedBy + '\',\'' + TestData1[i].rejectdate + '\',\'' + TestData1[i].rejectreason + '\')" >R</span>';
                                }
                                mydata += '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"> ';
                             //   if (TestData1[i].IsSampleCollected != "N" && TestData1[i].IsSampleCollected != "R") {
                                    mydata += '<img src="../../Images/print.gif" style="cursor:pointer" onclick="getBarcodeDetail(\'' + TestData1[i].BarcodeNoB + "#" + "B" + '\',\'' + TestData1[i].Investigation_ID + '\')" />';
                               // }
                                mydata += '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"> ';
                                if (TestData1[i].IsSampleCollected != "N" && TestData1[i].IsSampleCollected != "R" && TestData1[i].Result_Flag == "0") {
                                    mydata += '<span title="Click To Reject Sample" style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="$showRejectSample(\'' + TestData1[i].TestID + '\')" >R</span>';
                                }
                                mydata += '</td>';
                                mydata += '<td id="tdreporttype" style="display:none;">' + TestData1[i].reporttype + '</td>';
                                mydata += '<td id="tdPrePrintedBarcode" style="display:none;">' + TestData1[i].PrePrintedBarcode + '</td>';
                                mydata += '<td id="tdTestID" style="display:none;">' + TestData1[i].TestID + '</td>';
                                mydata += '<td id="tdPerFormingCenter" style="display:none;">' + TestData1[i].PerformingTestCentre + '</td>';
                                mydata += '<td id="tdLedgertransactionNo" style="display:none;">' + TestData1[i].LedgerTransactionNo + '</td>';
                                mydata += '<td id="tdTokenNo" style="display:none;">' + TestData1[i].TokenNo + '</td>';
                                mydata += "</tr>";
                                $('#tbsample').append(mydata);
                                if (TestData1[i].PrePrintedBarcode == "1")
                                    $('#txtSINNo').show();
                                if (TestData1[i].IsSampleCollected == "N")
                                    $('#btnsamplecollect').show(); 
                                    $('#btnCall').show(); 
                                    $('#btnUnCall').show();

                            }
                        }
                    }
                });
            }
            function setbarcodetoall(ctrl) {
                var val = $(ctrl).val();
                var name = $(ctrl).attr("name");
                $('input[name="' + name + '"]').each(function () {
                    $(this).val(val);
                });
            }
            function samebarcode(ctrl) {
                var value = $(ctrl).val();
                var classname = $(ctrl).attr("class")
                var inputs = $("." + classname);
                for (var i = 0; i < inputs.length; i++) {
                    $(inputs[i]).val(value);
                }
                $('#tbsample tr').each(function () {
                    var row = $(this).closest("tr");
                    var date = $(row).find('#spnScRequestdate').text().trim();
                    if (date == '') {
                        var ss = new Date().format("dd-MMM-yy hh:mm tt");
                        $(row).find('#spnScRequestdate').text(ss);
                    }
                });
            }
            function setclass(cltr) {
                var value = $(cltr).val();
                var Sampletype = $(cltr).closest("tr").find("#sampletypes").val();
                var classname = $(cltr).closest("tr").find("#tdsinno").attr("class");
                $(cltr).closest("tr").find("#tdsinno").removeClass(classname);
                $(cltr).closest("tr").find("#tdsinno").addClass('sample_' + Sampletype + '')
            }
            function getBarcodeDetail(LedgertransactionNo, Investigation_ID) {

                try {
                    serverCall('SampleCollectionLab.aspx/getBarcode', { LedgertransactionNo: LedgertransactionNo, Investigation_ID: Investigation_ID }, function (response) {
                        window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source';
                    });
                }
                catch (e) {
                    madelAlert("Barcode Printer Not Install");
                }
            }

            function GetData() {
                var validate = "0";
                var BarcodeNo = "0";
                var HISTODoctorID = "";
                var HistoCytoSampleDetail = ""
                var SampleTypeID = "";
                var SampleType = "";
                var HistoCytoStatus = "";
                var SampleCollectiondate = "";
                var Ledgertransaction = "";
                var TokenNo = "";
               
                var dataPLO = new Array();
                $('#tbsample tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "saheader") {
                        if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {
                            if ($(this).closest("tr").find("#tdreporttype").text() == "7") {
                                HISTODoctorID = $(this).find('#ddlDoctorPath').val();
                                HistoCytoSampleDetail = $(this).find('#ddlnoofsp').val() + '^' + $(this).find('#ddlnoofsli').val() + '^' + $(this).find('#ddlnoofblock').val();
                                SampleTypeID = $('#tdss').text();
                                SampleType = $('#txtspecimentype').val();
                                HistoCytoStatus = "Assigned";
                                Ledgertransaction = $(this).find("#tdLedgertransactionNo").text();
                                TokenNo = $(this).find('#tdTokenNo').text();
                            }
                            else {
                                SampleTypeID = $(this).find('#sampletypes').val();
                                SampleType = $(this).find('#sampletypes option:selected').text();
                                Ledgertransaction = $(this).find("#tdLedgertransactionNo").text();
                                TokenNo = $(this).find('#tdTokenNo').text();
                            }
                            if ($(this).closest("tr").find("#tdPrePrintedBarcode").text() == "1") {
                                if ($(this).find('#tdsinno').val() == "") {
                                    validate = "1";
                                }
                                else {
                                    BarcodeNo = $(this).find('#tdsinno').val();
                                    if (BarcodeNo != "") {
                                        SampleCollectiondate = $('#spnScRequestdate').text();
                                    }
                                }
                            }
                            else
                                BarcodeNo = $(this).find('#tdsinno').text();
                            if ($(this).closest("tr").find("#sampletypes").val() == "0") {
                                validate = "3";
                            }
                            dataPLO.push($(this).closest("tr").attr("id") + "#" + SampleTypeID + "#" + SampleType + "#" + HISTODoctorID + "#" + BarcodeNo + "#" + $(this).find('#tdPerFormingCenter').text() + "#" + HistoCytoSampleDetail + "#" + HistoCytoStatus + "#" + SampleCollectiondate + "#" + Ledgertransaction + "#" + TokenNo);
                        }
                    }
                });
                if (validate == "1")
                    return "1";
                else if (validate == "2")
                    return "2";
                else if (validate == "3")
                    return "3";
                else
                    return dataPLO;
            }
            var validatemesg = "";
            function Validation() {
                var count = 0;
                $('#tbsample tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "saheader") {
                        if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {

                            var SCRequestdate = $.trim($(this).find('#spnScRequestdatetime').text());
                            var SCWithdrawdate = $.trim($(this).find('#spnScRequestdate').text());

                            if (SCWithdrawdate == "") {
                                SCWithdrawdate = new Date().format("dd-MMM-yy hh:mm tt")
                            }
                            if (SCRequestdate != "") {
                                if (new Date(SCRequestdate) > new Date(SCWithdrawdate)) {
                                    count += 1;
                                    validatemesg = "Request date is greater then Withdraw date";
                                }
                            }
                        }
                    }
                });
                if (count > 0) {
                    return false;
                }
                return true;
            }
            function SampleCollection() {
                if (Validation()) {
                    var data = GetData();
                    if (data == "1") {
                        modelAlert("Please Enter The Barcode No");
                        return;
                    }
                    if (data == "2") {
                        modelAlert("Please Select At Least One Sample ");
                        return;
                    }
                    if (data == "3") {
                        modelAlert("Please Select The Sample Type");
                        return;
                    }
                    if (data.length == 0) {
                        modelAlert(" Call A Patient First After This You Can Collect Sample ");
                        return;
                    }
                    else {
                        serverCall('SampleCollectionLab.aspx/SaveSamplecollection', { data: data }, function (response) {

                            if (response == "1") {
                                $('#tbsample tr').slice(1).remove();
                                getBarcodeDetail($('#spnledgerno').text() + "#" + "L", "");
                                $('#spnledgerno').text('');
                                modelAlert("Record Saved Successfully", function () {
                                    SearchPatientDetails();
                                });
                            }
                        });
                    }
                }
                else {
                    modelAlert(validatemesg);
                }
            }

            function CallPatient() {
                if (Validation()) {

                    var data = GetData();
                    if (data == "1") {
                        modelAlert("Please Enter The Barcode No");
                        return;
                    }
                    if (data == "2") {
                        modelAlert("Please Select At Least One Sample ");
                        return;
                    }
                    if (data == "3") {
                        modelAlert("Please Select The Sample Type");
                        return;
                    }
                    if (data.length == 0) {
                        modelAlert(" Please Select At Least One Sample For Call Patient");
                        return;
                    }

                    else {
                        serverCall('SampleCollectionLab.aspx/SaveCalledPatient', { data: data, CollectionRoomName: $('#ddlRoomName option:selected').text(), FromDate: $('#FrmDate').val(), ToDate: $('#ToDate').val() }, function (response) {

                            if (response.split('#')[0] == "1") {
                                modelAlert("Called Patient Saved Successfully", function () {
                                    showbarcodedata(response.split('#')[1]);
                                });
                            }
                            else { modelAlert(response.split('#')[0]); }
                        });


                    }
                }
            }

            function UnCallPatient() {

                if (Validation()) {

                    var data = GetData();
                    if (data == "1") {
                        modelAlert("Please Enter The Barcode No");
                        return;
                    }
                    if (data == "2") {
                        modelAlert("Please Select At Least One Sample ");
                        return;
                    }
                    if (data == "3") {
                        modelAlert("Please Select The Sample Type");
                        return;
                    }
                    if (data.length == 0) {
                        modelAlert(" Please Select At Least One Sample For Call Patient");
                        return;
                    }

                    else {
                        serverCall('SampleCollectionLab.aspx/SaveUnCalledPatient', { data: data, CollectionRoomName: $('#ddlRoomName option:selected').text(), FromDate: $('#FrmDate').val(), ToDate: $('#ToDate').val() }, function (response) {

                            if (response.split('#')[0] == "1") {
                                modelAlert("UnCalled Patient Successfully", function () {
                                    showbarcodedata(response.split('#')[1]);
                                });
                            }
                            else { modelAlert(response.split('#')[0]); }
                        });


                    }
                }

            }
            function call() {
                if ($('#hd').prop('checked') == true) {
                    $('#tbsample tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "saheader") {
                            $(this).closest("tr").find('#mmchk:not(:disabled)').prop('checked', true);
                        }
                    });
                }
                else {
                    $('#tbsample tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "saheader") {
                            $(this).closest("tr").find('#mmchk:not(:disabled)').prop('checked', false);
                        }
                    });
                }
            }
            function blockSpecialChar(e) {
                var k = e.keyCode;
                return ((k > 64 && k < 91) || (k > 96 && k < 123) || k == 8 || k == 32 || (k >= 48 && k <= 57));
            }

            function getDoctorOrderreort() {
                if ($('#txtdate').val() == '') { modelAlert("Please Select From Date"); return; }
                if ($('#txtToDate').val() == '') { modelAlert("Please Select To Date"); return; }
                if ($('#txtFromTime').val() == '') { modelAlert("Please Select From Time"); return; }
                if ($('#txtToTime').val() == '') { modelAlert("Please Select To Time"); return; }
               

                serverCall('SampleCollectionLab.aspx/getDoctorOrderReport', { date: $('#txtdate').val(), Todate: $('#txtToDate').val(), fromTime: $('#txtFromTime').val(), toTime: $('#txtToTime').val(), Location: $("#ddlLocation").val() }, function (response) {
                    var data = JSON.parse(response);

                    if (data.status) {
                        window.open('../../Design/common/ExportToExcel.aspx');
                    }
                    else { modelAlert(data.message); }


                });
            }
    </script>
    <style type="text/css">
        .blink-two {
            animation: blinker-two 2.6s linear infinite;
        }

        @keyframes blinker-two {
            100% {
                opacity: 0;
            }
        }
    </style>
</asp:Content>

