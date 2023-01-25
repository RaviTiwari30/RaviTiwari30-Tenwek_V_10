
<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineResultEntry_Culture.aspx.cs" Inherits="Design_Lab_MicroCultureLabResult" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Lab/Popup.ascx" TagName="PopUp" TagPrefix="uc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="Style/ResultEntryCSS.css" rel="stylesheet" />
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <link href="../../Scripts/fancybox/jquery.fancybox.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <%--<script type="text/javascript" src="Script/ResultEntryJS.js"></script>--%>

    <style type="text/css">
        #MainInfoDiv {
            height: 450px !important;
        }
    </style>

    <div id="popup_box" style="height: 120px;display:none">
        <a href="javascript:void(0);" id="popupBoxClose" onclick="unloadPopupBox()">Close</a>
        Approval Type::<asp:DropDownList ID="ddlapptype" runat="server">
            <asp:ListItem>Select</asp:ListItem>
            <asp:ListItem>Interim</asp:ListItem>
            <asp:ListItem>Final</asp:ListItem>
        </asp:DropDownList>
        <br />
        <br />
        <input type="button" class="savebutton" value="Save" onclick="SaveApproved()" />&nbsp;&nbsp;
            <input type="button" class="resetbutton" value="Cancel" onclick="unloadPopupBox()" />
    </div>


    <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" >
            <div style="text-align: center;">
                <b>&nbsp;Result Entry Culture</b>
            </div>
            <div class="Purchaseheader">
                Search Option
             &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="AdministratorLblError" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTotalPatient" ForeColor="Red" runat="server" CssClass="AdministratorLblError" />
            </div>
            <div class="col-md-1"></div>
        <div class="col-md-24">
            <div class="row">
            <div class="col-md-3">
                <label class="pull-left">
                <asp:DropDownList ID="ddlSearchType" runat="server" Width="123px">
                    <asp:ListItem Value="pli.BarcodeNo" Selected="True">Barcode No.</asp:ListItem>
                    <asp:ListItem Value="lt.PatientID">UHID No.</asp:ListItem>
                    <asp:ListItem Value="pli.LedgerTransactionNo">Patient Name</asp:ListItem>


                </asp:DropDownList></label><b class="pull-right">:</b></div>
                <div class="col-md-5">
                <asp:TextBox ID="txtSearchValue" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                    </div>
                <div class="col-md-3">
                      <label class="pull-left">Department</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:DropDownList ID="ddlDepartment" CssClass="chosen" runat="server"></asp:DropDownList>
                </div>
                 <div class="col-md-3">
                    <label class="pull-left">Status</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:DropDownList ID="ddlSampleStatus" runat="server" CssClass="chosen" >
                    <asp:ListItem Value="  and pli.isSampleCollected<>'N' ">All Patient</asp:ListItem>
                    <asp:ListItem Value=" and pli.CultureStatus='Incubation' and pli.Result_flag=0  and pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' " >Pending</asp:ListItem>
                    <asp:ListItem Value=" and pli.isSampleCollected='S' and pli.Result_flag=0 ">Sample Collected</asp:ListItem>
                    <asp:ListItem Value=" and pli.isSampleCollected='Y' and pli.Result_flag=0 ">Sample Receive</asp:ListItem>
                    <asp:ListItem Value=" and  pli.Result_Flag='0'  and pli.isSampleCollected<>'R'  and (select count(*) from mac_data md where md.Test_ID=pli.Test_ID  and md.reading<>'')>0 ">Machine Data</asp:ListItem>
                    <asp:ListItem Value=" and pli.Result_flag=1 and pli.approved=0 and pli.ishold='0'   and pli.isSampleCollected<>'R' ">Tested</asp:ListItem>
                    <asp:ListItem  Value=" and pli.Result_flag=1 and pli.isForward=1 and pli.Approved=0  and pli.isSampleCollected<>'R' ">Forwarded</asp:ListItem>
                    <asp:ListItem Value=" and pli.Approved=1 and pli.isPrint=0 and pli.isSampleCollected<>'R' ">Approved</asp:ListItem>
                    <asp:ListItem Value=" and pli.isHold='1'  ">Hold</asp:ListItem>
                    <asp:ListItem Value=" and pli.isPrint=1  and pli.isSampleCollected<>'R' and pli.Approved=1 ">Printed</asp:ListItem>
                    <asp:ListItem Value=" and pli.isSampleCollected='R'  ">Rejected Sample</asp:ListItem>
                    <%--<asp:ListItem  Value=" and pli.Preliminary='1' and  pli.Approved=0   and pli.isPrint=0  ">Preliminary report</asp:ListItem>--%>
                </asp:DropDownList>
                </div>
                </div>
            <div class="row">
                <div class="col-md-3">
                        <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                  <div class="col-md-5">
                       <asp:TextBox ID="txtFormDate" CssClass="AdministratorTextinputText" ClientIDMode="Static" runat="server" ReadOnly="true" Width="150px"></asp:TextBox>
                  <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFormDate">
                        </cc1:CalendarExtender>
                       <asp:TextBox ID="txtFromTime" runat="server" Width="90px"></asp:TextBox>
                <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                    AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                </cc1:MaskedEditExtender>
                <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                    ControlExtender="mee_txtFromTime"
                    ControlToValidate="txtFromTime"
                    InvalidValueMessage="*">
                </cc1:MaskedEditValidator>
                  </div>
                  <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                  <div class="col-md-5">
                       <asp:TextBox ID="txtToDate" CssClass="AdministratorTextinputText" ClientIDMode="Static" runat="server" ReadOnly="true" Width="150px"></asp:TextBox>
                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate">
                        </cc1:CalendarExtender>
                      <asp:TextBox ID="txtToTime" runat="server" Width="90px"></asp:TextBox>
                <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                    AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                </cc1:MaskedEditExtender>
                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                    ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                    InvalidValueMessage="*">
                </cc1:MaskedEditValidator>
                  </div>
                  <div class="col-md-3">
                    <label class="pull-left"> <asp:CheckBox ID="chkPanel0" runat="server" onClick="BindTest();" Text="Test :" Style="font-weight: 700" /></label>
                      <b class="pull-right">:</b>
            </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlinvestigation" class="ddlinvestigation  chosen-select"  runat="server">
                </asp:DropDownList>
                </div>
            </div>
             <div class="row" style="display:none;">
                    <div class="col-md-3">
                     <label class="pull-left"></label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5" style="text-align:left">
                </div>
                 <div class="col-md-3"></div>
                <div class="col-md-5" style="text-align:center">
                 
                </div>
                  <div class="col-md-3">
                     <label class="pull-left"></label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5" style="text-align:left">
                 <input id="ChkIsUrgent" type="checkbox" /> <strong>Urgent Test </strong>
                </div>
                 
            </div>
            <div class="row" style="text-align:center;">
                <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="SearchSampleCollection();" />
            </div>
             <div class="row" style="margin-left:159px;">
                 <div>
                    <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:lightyellow;" class="circle Collected"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Collected</b>
                            <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:lightgreen;" class="circle Received"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Pending</b>
                             <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle MacData"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">MacData</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle Tested"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Tested</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle ReRun"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">ReRun</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle Forwarded"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Forwarded</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle Approved"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Approved</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle Printed"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Printed</b>
                     <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle Hold"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Hold</b>
                      <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink;" class="circle Rejected"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Rejected</b></div>
             </div>
             <div class="col-md-1"></div> 
            </div>

            <div class="content" style="display: none;">
                <asp:DropDownList ID="ddlZSM" Width="155px" runat="server" Style="display: none;">
                </asp:DropDownList>

                  <asp:CheckBox ID="chkcentre" runat="server" onClick="BindCentre();" Text="Centre :" Style="font-weight: 700; display: none;" />
                <asp:DropDownList ID="ddlCentreAccess" Width="235px" Style="display: none;" runat="server">
                    <asp:ListItem Value="ALL">ALL</asp:ListItem>
                </asp:DropDownList>

                <asp:CheckBox ID="chkPanel" runat="server" onClick="BindPanel();" Text="Rate Type :" Style="font-weight: 700; display: none;" />
                <asp:DropDownList ID="ddlPanel" runat="server" TabIndex="8" Width="200px" Style="display: none;">
                </asp:DropDownList>


                <asp:DropDownList ID="ddlMachine" Width="100px" runat="server" Style="display: none;">
                </asp:DropDownList>

                <asp:CheckBox ID="chremarks" Font-Bold="true" runat="server" Text="Remarks Status" Style="display: none;" />
                <asp:CheckBox ID="chcomments" Font-Bold="true" runat="server" Text="Comments Status" Style="display: none;" />


                &nbsp;


                &nbsp;&nbsp;&nbsp;
                <strong>Urgent Investigations </strong>&nbsp;
                &nbsp;&nbsp;
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div id="divPatient" class="vertical" style="max-height:400px;"></div>
            <div id="MainInfoDiv" class="vertical" style="max-height:400px;">
              
                <div class="Purchaseheader">
                    <div class="DivInvName" style="color: Black; cursor: pointer; font-weight: bold;"></div>
                </div>
                <div style="height: 411px; overflow: auto;">
                    &nbsp;&nbsp;<strong>Report Type:</strong> 
                        <asp:DropDownList ID="ddlreportnumber"  runat="server" onchange="pickmeagain()" Width="395px">
                      <asp:ListItem value="Preliminary 1">Preliminary 1</asp:ListItem>
                      <asp:ListItem value="Preliminary 2">Preliminary 2</asp:ListItem>
                      <asp:ListItem value="Preliminary 3">Preliminary 3</asp:ListItem>
                      <asp:ListItem value="Final Report">Final Report</asp:ListItem>
                      </asp:DropDownList>
                    <table width="100%">
                        <tr>
                            <td width="40%" valign="top">
                                <div id="divInvestigation">
                                </div>
                            </td>
                            <td width="60%" valign="top">
                                <%--<div id="divantibody" style="display: none; background-color: lightyellow;">--%>
                                <div id="divantibody" style="display: none; background-color: white;">
                                    <div class="Purchaseheader">Antibiotic Entry</div>
                                    <div id="AntiBioList" style="max-height: 344px; overflow: auto;">
                                        <table id="AntiBioTicList" style="width: 99%; border-collapse: collapse">
                                            <tr id="antiheader">
                                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                                <td class="GridViewHeaderStyle">Antibiotic</td>
                                                <td class="GridViewHeaderStyle">Interpretation</td>
                                                <td class="GridViewHeaderStyle">MIC</td>
                                                <td class="GridViewHeaderStyle" style="display:none">BreakPoint</td>
                                                <td class="GridViewHeaderStyle" style="display:none">MIC/BP</td>
                                                <td class="GridViewHeaderStyle" style="display:none">Group</td>
                                            </tr>
                                        </table>
                                    </div>
                                    <table width="99%;">
                                        <tr style="background-color: white">
                                            <td style="font-weight: bold;">Select Organism: </td>
                                            <td>
                                                <asp:DropDownList ID="ddlOrganism" runat="server" Width="400px" onchange="AddAntibotic('1')" ></asp:DropDownList></td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>


                <div id="SelectedPatientinfo">
                </div>
                <div style="display: none;">
                    <br />
                    <input id="btnUpdateBarcodeInfo" class="AdministratorButton" type="button" value="Save" style="display: none" onclick="UpdateBarcodes();" disabled />
                </div>
                <div style="padding-top: 2px;" class="btnDiv">
                    <input id="btnPreLabObs" type="button" value="<<" class="demo AdministratorButton" onclick="PreLabObs();" style="width: 50px; height: 25px" disabled />
                    <input id="btnNextLabObs" type="button" value=">>" class="demo AdministratorButton" onclick="NextLabObs();" style="width: 50px; height: 25px" disabled />
                    <input id="btnSaveLabObs" type="button" value="Save" class="AdministratorButton btnForSearch demo SampleStatus" onclick="Save();" style="width: auto; height: 25px;" disabled />
                    <%                  
                    if (ApprovalId == "")
                    { %>                           
            <%}
                    else
                    {
                        if (ApprovalId == "1" || ApprovalId == "3" || ApprovalId == "4")
                        {%>
                <asp:DropDownList ID="ddlApprove" runat="server" Width="150px" ></asp:DropDownList>
                    <input id="btnApprovedLabObs" type="button" value="Approved" class="AdministratorButton btnForSearch  SampleStatus demo" onclick="Approved();" style="width:auto;height:25px;" disabled/>
                <input id="btnPreliminary" type="button" value="Preliminary Report" class="AdministratorButton btnForSearch  SampleStatus demo" onclick="Preliminary();" style="width:auto;height:25px;display:none;" disabled/>
                 <input id="btnholdLabObs" type="button" value="Hold" class="AdministratorButton btnForSearch  SampleStatus demo" onclick="Hold();" style="width:auto;height:25px;display:none;" disabled/>
                <% if (ApprovalId == "4" || ApprovalId == "3")
                   {%>
                    <input id="btnNotApproveLabObs" type="button" value="Not Approved" class="AdministratorButton btnForSearch  SampleStatus demo" onclick="NotApproved();" style="width:auto;height:25px;" disabled/>
                    
                <%if (ApprovalId == "4")
                  { 
                  %>
                   <input id="btnUnholdLabObs" type="button" value="Un Hold " class="AdministratorButton btnForSearch  SampleStatus demo" onclick="UnHold();" style="width:auto;height:25px;"disabled/>
                 <% }
                   }
                        }

                        if (ApprovalId == "2" || ApprovalId == "3" || ApprovalId == "4")
                        {%>
                    <input id="btnForwardLabObs" type="button" value="Forward" class="AdministratorButton btnForSearch  SampleStatus demo" style="height:25px;"  onclick="Forward();" disabled />
                <%}
                   
%>
<input id="btnUnForwardLabObs" type="button" value="Un Forward" class="AdministratorButton btnForSearch  SampleStatus demo" onclick="UnForward();"  />
<%

                    }%>
                    <input id="btnAddFileLabObs" type="button" value="Add File" class="AdministratorButton" onclick="fancypopup(LedgerTransactionNo);" style="width: auto; height: 25px;" />

                    <input id="btnaddreport" type="button" value="Add Report" class="AdministratorButton" onclick="AddReport(LedgerTransactionNo, _test_id)" style="width: auto; height: 25px;" />


                    <input id="btnPrintReportLabObs" type="button" value="Print PDF" class="AdministratorButton btnForSearch demo " onclick="PrintReport('0');" disabled style="width: auto; height: 25px;" />
                     <input id="btnPreview" type="button" value="Preview PDF" class="AdministratorButton btnForSearch demo " onclick="PrintReport('1');" disabled style="width:auto;height:25px;"/>
                    <input id="btnPatientDetail" type="button" value="Patient Detail" class="AdministratorButton" style="width: auto; height: 25px;" />
                    <a id="various2" style="display: none">Ajax</a>
                    <input id="btnSide" type="button" value="Main List" class="AdministratorButton" onclick="$('#divPatient').toggle(); $('#MainInfoDiv').toggle(); hot1.render(); hot2.render();" style="width: auto; height: 25px;" />
                </div>
                <div class="row">
                    <span style="color: black; font-weight: bold;">Incubation Date:</span>
                    <asp:TextBox ID="txtindate" CssClass="AdministratorTextinputText" runat="server" ReadOnly="true" Width="130px"></asp:TextBox>
                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtindate" TargetControlID="txtindate" OnClientDateSelectionChanged="checkDate" />

                 <asp:TextBox ID="txtintime" runat="server" Width="100px"></asp:TextBox>
                                 <cc1:MaskedEditExtender runat="server" ID="MaskedEditExtender1" Mask="99:99:99" TargetControlID="txtintime"
                                                             AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                                                            
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="MaskedEditValidator1"
                                        ControlExtender="mee_txtFromTime"
                                        ControlToValidate="txtintime"
                                        InvalidValueMessage="*"  >
                                 </cc1:MaskedEditValidator>

                <asp:DropDownList ID="DropDownList1" Width="155px" runat="server" style="display:none;">
                </asp:DropDownList>
                    <asp:DropDownList ID="ddlTestDon" runat="server" onchange="PicSelectedRow()" style="display:none;"></asp:DropDownList>
                </div>
            </div> 
            <uc1:PopUp id="popupctrl" runat="server" /> 
            <div id="myModal" class="modal fade"  >
              <!-- Modal content -->
                <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="myModal" aria-hidden="true">×</button>
                  <strong class="modal_header" style="font-size:20px;">Modal Header</strong>
                </div>
                <div class="modal-body">
                  <p id="CommentBox"><span id="CommentHead">Comments :&nbsp;</span><select id="ddlCommentsLabObservation"  onchange="ddlCommentsLabObservation_Load(this.value);" style="margin-left: 5px;height: 25px;width: 200px;"></select>

                    &nbsp;<span id="sprequiredfile" style="font-weight: bold;background-color: lightcyan;padding: 5px;display:none;"></span></p>
                    <p>
                      <input type="file" name="file_upload" id="file_upload" style="display:none"  />
                      <CKEditor:CKEditorControl ID="CKEditorControl1" BasePath="~/ckeditor" runat="server" Height="200px"></CKEditor:CKEditorControl>
                  </p>
                </div>
                <div class="modal-footer" id="DIVMODELFOOTER">                  
                </div>
              </div>
                    </div>
            </div>
        </div>
    </div>
    <div id="deltadiv" style="display: none; position: absolute;">
    </div>

    <select size="4" style="position: absolute; min-height: 100px; display: none;width:200px;height:100px" class="helpselect" onkeyup="addtotext1(this,event)" ondblclick="addtotext(this)">
        <option value="Intermediate">Intermediate</option>
        <option value="Resistant">Resistant</option>
        <option value="Sensitive">Sensitive</option>

    </select>


    <script type="text/javascript">
        $(document).ready(function () { 
            $('.chosen').chosen();
            $('#<%=txtSearchValue.ClientID%>').keypress(function (ev) {
                 if (ev.which === 13)
                     SearchSampleCollection();
            });

            $('.helpselect').keydown(function (e) {
               if(e.keyCode==13)
                    e.preventDefault();
            });
            $('.helpselect').keyup(function (e) {
                if (e.keyCode == 13)
                e.preventDefault();
            });
           
         });
    </script>
    <script type="text/javascript">
        function BindTest() {
          //  $.blockUI();
            var ddlDoctor = $("#<%=ddlinvestigation.ClientID %>");
            ddlDoctor.find('option').remove();
               var chkDoc = $("#<%=chkPanel0.ClientID %>");
               if (($('#<%=chkPanel0.ClientID%>').prop('checked') == true)) {
                   $("#<%=ddlinvestigation.ClientID %> option").remove();
                ddlDoctor.append($("<option></option>").val("").html(""));
                $.ajax({
                    url: "MachineResultEntry_Culture.aspx/GetTestMaster",
                    data: '{}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        PanelData = $.parseJSON(result.d);
                        if (PanelData.length == 0) {
                        }
                        else {
                            for (i = 0; i < PanelData.length; i++) {
                                ddlDoctor.append($("<option></option>").val(PanelData[i]["testid"]).html(PanelData[i]["testname"]));
                            }
                        }
                        ddlDoctor.chosen();
                     //   $.unblockUI();
                    },
                    error: function (xhr, status) {
                        modelAlert("Error ");
                        ddlDoctor.chosen();
                       // $.unblockUI();
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                $("#<%=ddlinvestigation.ClientID %> option").remove();
                   ddlDoctor.chosen();
               // $.unblockUI();
            }
        };
    </script>

    <script type="text/javascript">
        var PatientData = '';
        var LabObservationData = '';
        var _test_id = '';
        var _barcodeno = '';
        var hot2;
        var modal = "";
        var span = "";
        var currentRow = 1;
        var resultStatus = "";
        var LedgerTransactionNo = "";
        var MYSampleStatus = "";
        var elt;
        // for image crop
        var Year = '<%=Year %>';
        var Month = '<%=Month %>';
        var image;
        var ImgTag;
        var savedvalue = "";
        var formattedDate;
        //end
        var mouseX;
        var mouseY;
        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });
        function getme(testid) {
           // alert(testid);
            var turl = "../../Design/Lab/showreading.aspx?TestID=" + testid;
            //alert(turl);
            $.ajax({
                url: turl,
                dataType: 'html',
                success: function (html) {
                    //... rest of your code that should be added into the load function.
                    debugger;
                    //alert(html);
                    $('#deltadiv').html(html).css({ 'top': mouseY, 'left': mouseX }).show();
                }
            });
        }
        $(document).ready(function () {
            $('body').click(function () {
                $('#deltadiv').hide();
            });
        });
        function hideme() {
            $('#deltadiv').hide();
        }
        $(document).ready(function () {
            // ManageDivHeight();
            $('#MainInfoDiv').hide();
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            $('#divPatient').removeClass('vertical');
            $('#divPatient').addClass('horizontal');
            // $('#divPatient').css('height', '450px');
            $('#MainInfoDiv').hide();
            $('.btnDiv').hide();
            $('#btnSide').hide();
            $('#btnUpdateBarcodeInfo').show();
                <%}%>
            elt = document.getElementById('<%=ddlSampleStatus.ClientID%>');
           // MYSampleStatus = elt.options[elt.selectedIndex].text;
            //UpdateSampleStatus();
            $('#<%=ddlSampleStatus.ClientID%>').change(function () {
                $('.SampleStatus').hide();
            });
            modal = document.getElementById('myModal');
            // Get the button that opens the modal

            // Get the <span> element that closes the modal
            span = document.getElementsByClassName("close")[0];
            // When the user clicks on the button, open the modal 
            //btn.onclick = function () {
            //    modal.style.display = "block";
            //}
            // When the user clicks on <span> (x), close the modal
            span.onclick = function () {
                modal.style.display = "none";
            }
            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        });
        function ManageDivHeight() {
            $('#divInvestigation').removeClass('vertical');
            $('#divPatient').removeClass('vertical');
            $('#divInvestigation').addClass('horizontal');
            $('#divPatient').addClass('horizontal');
        }
        function UpdateSampleStatus(mystatus) {

            MYSampleStatus = mystatus;
            $('.SampleStatus').hide();
            if (MYSampleStatus == "Forwarded") {
                $('#btnApprovedLabObs').show();
                $('#btnUnForwardLabObs').show();  
            }
            if (MYSampleStatus == "Tested" || MYSampleStatus == "Preliminary report") { $('#btnForwardLabObs').show(); $('#btnApprovedLabObs').show(); }
            if (MYSampleStatus == "Approved" || MYSampleStatus == "Printed") { $('#btnNotApproveLabObs').show(); }
            if (MYSampleStatus == "Pending" || MYSampleStatus == "ReRun" || MYSampleStatus == "Tested" || MYSampleStatus == "Machine Data" || MYSampleStatus == "Preliminary report" || MYSampleStatus == "Sample Receive") { $('#btnSaveLabObs').show(); $('#btnApprovedLabObs').show(); }
            if (MYSampleStatus == "Tested" && MYSampleStatus != "Approved" || MYSampleStatus == "Preliminary report") { }
            if (MYSampleStatus == "Pending" || MYSampleStatus == "ReRun" || MYSampleStatus == "Tested") { $('#btnholdLabObs').show(); }
            if (MYSampleStatus == "Hold") { $('#btnUnholdLabObs').show(); $('#btnApprovedLabObs').hide(); }

         

           

        }

        var
                        data,
                        container1,
                        hot1;

        function SearchSampleCollection() {
            var investigationID = "";
            var PanelId = "";



            PanelId = $('#<%=ddlPanel.ClientID%>').val();
                investigationID = $('#<%=ddlinvestigation.ClientID%>').val();
                //alert(investigationID);

                $('#divPatient').show();
                $('#MainInfoDiv').hide();

                var isUrgent = $("#ChkIsUrgent").is(':checked') ? 1 : 0;

                $('#btnSave').hide();
                $('#divPatient').html('');
                $('#divInvestigation').html('');
                $('.demo').attr('disabled', true);

                var chremarks = 0;
                if ($("#ctl00_ContentPlaceHolder1_chremarks").prop("checked") == true)
                    chremarks = 1;

                var chcomments = 0;
                if ($("#ctl00_ContentPlaceHolder1_chcomments").prop("checked") == true)
                    chcomments = 1;
                $("#btnSearch").attr('disabled', 'disabled').val('Searching...');
              //  $.blockUI();
                $.ajax({
                    url: "MachineResultEntry_Culture.aspx/PatientSearch",
                    data: '{ SearchType: "' + $("#<%=ddlSearchType.ClientID %>").val() + '",SearchValue:"' + $("#<%=txtSearchValue.ClientID %>").val() + '",FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '",SmpleColl:"' + $("#<%=ddlSampleStatus.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '",MachineID:"' + $('#<%=ddlMachine.ClientID%>').val() + '",ZSM:"' + $("#<%=ddlZSM.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",TimeTo:"' + $("#<%=txtToTime.ClientID%>").val() + '",isUrgent:"' + isUrgent + '",InvestigationId:"' + investigationID + '",PanelId:"' + PanelId + '", SampleStatusText:"' + $('#<%=ddlSampleStatus.ClientID %> option:selected').text() + '",chremarks:"' + chremarks + '",chcomments:"' + chcomments + '"}', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        $('.SampleStatus').hide();
                        $('.SampleStatus').attr('disabled', true);

                        PatientData = $.parseJSON(result.d);
                        if (PatientData == "-1") {
                            $('#<%=lblTotalPatient.ClientID%>').text('');
                            $('#btnUpdateBarcodeInfo').attr('disabled', true);
                            $("#btnSearch").removeAttr('disabled').val('Search');
                         //   $.unblockUI();
                            modelAlert('Your Session Expired.... Please Login Again');
                            return;
                        }
                        if (PatientData.length == 0) {
                            $('#<%=lblTotalPatient.ClientID%>').text('');
                            $('#btnUpdateBarcodeInfo').attr('disabled', true);
                            $("#btnSearch").removeAttr('disabled').val('Search');
                          //  $.unblockUI();
                            // $("#<%=lblMsg.ClientID %>").text('No Record Found');
                            modelAlert('No Record Found');
                            return;
                        }
                        else {
                            //UpdateSampleStatus();
                            currentRow = 1;
                            $("#<%=lblMsg.ClientID %>").text('');
                            $('#<%=lblTotalPatient.ClientID%>').text('Total Patient: ' + PatientData.length);
                            $('#btnUpdateBarcodeInfo').attr('disabled', false);
                            // var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                            // $('#divPatient').html(output);

                            data = PatientData;
                            container1 = document.getElementById('divPatient');
                            hot1 = new Handsontable(container1, {
                                data: PatientData,
                                colHeaders: [
                          "S.No.", "Reg. Date", "Barcode No.", "UHID No.", "Patient Name", "Age/Sex", "Tests", "Status","Attachement","Print" 
                                ],
                                //, "Detail", "View Doc.", "Print"
                                readOnly: true,
                                currentRowClassName: 'currentRow',
                                columns: [
                                { renderer: AutoNumberRenderer, width: '60px' },
                                { data: 'DATE' },
                               // { data: 'Centre' },
                               // { data: 'reportnumber' },
                               // { data: 'LedgerTransactionNo', renderer: safeHtmlRenderer },
                               // { data: 'LedgerTransactionNo' },
                                { data: 'BarcodeNo', width: '100px', renderer: safeHtmlRenderer },
                                { data: 'PatientID' },
                                { data: 'PName', width: '200px' },
                                { data: 'Age_Gender', width: '100px' }, // , renderer: safeHtmlRenderer 
                               // { data: 'Test', width: '200px', renderer: safeTestRenderer },
                                { data: 'Test', width: '200px' },
                                { data: 'Status' },
                               // { renderer: PatientDetail },
							    { renderer: ShowAttachment },
                                { renderer: PrintreportRenderer } //   , renderer: safeHtmlRenderer 
                                ],
                                stretchH: "all",
                                autoWrapRow: false,
                                manualColumnFreeze: true,
                                fillHandle: false,
                                // rowHeaders: true,
                                cells: function (row, col, prop) {
                                    var cellProperties = {};
                                    cellProperties.className = PatientData[row].Status;
                                    return cellProperties;
                                },
                                beforeChange: function (change, source) {
                                   // updateRemarks(change);
                                }
                            });
                            hot1.render();
                            hot1.selectCell(0, 0);
                          
                            //if (PatientData.length > 0)
                            //    SearchInvestigation(PatientData[0].ledgerTransactionNO);
                            $("#btnSearch").removeAttr('disabled').val('Search');
                           
                         //   $.unblockUI();
                            CallFancyBox();
                            return;
                        }
                    },
                    error: function (xhr, status) {
                        $("#btnSearch").removeAttr('disabled').val('Search');
                      //  $.unblockUI();
                        $('#divPatient').html('');
                        modelAlert('Please Contact to Administrator Support Team');
                        window.status = status + "\r\n" + xhr.responseText;
                    }

                });
                // ManageDivHeight();
            }


            function updateRemarks(change) {
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
                UpdateBarcodes(change[0][0], change[0][3]);
                <%}
            %>
                <%if (Util.GetString(Request.QueryString["cmd"]) != "changebarcode")
                  {%>
                SaveRemarksStatus(change[0][0], change[0][3]);
                <%}
            %>
            }
        function SaveRemarksStatus(row, _remarks) {

            //var TestIDWithLedgerTransactionNo = e.target.id;
            //console.log(row);
            var TestID = PatientData[row].Test_ID;
            var LedgerTransactionNo = PatientData[row].LedgerTransactionNo;
            //var Remarks = PatientData[row].RemarkStatus;
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/SaveRemarksStatus",
                data: '{ TestID: "' + TestID + '",Remarks:"' + _remarks + '",LedgerTransactionNo:"' + LedgerTransactionNo + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result == '1') {
                        modelAlert('Remarks Status Saved.');
                    }
                    if (result == '-1') {
                        modelAlert('Remarks Status Not Saved.');
                    }
                },
                error: function (xhr, status) {
                }
            });

        }

        function PatientDetail(instance, td, row, col, prop, value, cellProperties) {
            //  td.innerHTML = '<a target="_blank" id="aa" href="../Lab/PatientSampleinfoPopup.aspx?TestID=' + PatientData[row].Test_ID + '&LabNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../Images/view.GIF" style="border-style: none" alt="">     </a>';
            td.innerHTML = '  <img  src="../../Images/view.GIF" style="border-style: none" alt="" onclick="CommonPatientinfo(' + PatientData[row].LedgerTransactionNo + ', ' + PatientData[row].Test_ID + ', "Other");">   ';
            return td;
        }
        function ShowAttachment(instance, td, row, col, prop, value, cellProperties) {
            var MyStr1 = "";
            if (PatientData[row].DocumentStatus != "") {
           //     MyStr1 = MyStr1 + '<a target="_blank" id="mm"  href="../Lab/AddAttachment.aspx?LedgerTransactionNo=' + PatientData[row].LedgerTransactionNo + '"  class="various iframe"> <img  src="../../Images/attachment.png" style="border-style: none" alt=""></a>';
                MyStr1 = MyStr1 + '  <img  src="../../Images/attachment.png" style="border-style: none" alt="" onclick="fancypopup(' + PatientData[row].LedgerTransactionNo + ');">';
            }
            td.innerHTML = MyStr1;
            return td;
        }

        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML              
            if (PatientData[row].RemarkStatus != "") {
                MyStr = MyStr + '<img src="../../Images/Remark.jpg" style="width:20px; Height:25px" alt=' + PatientData[row].RemarkStatus + '/>';

            }
            if (PatientData[row].Urgent == 'Y') {
                MyStr = MyStr + '<img title="Urgent" src="../../images/urgent.gif"/>';
            }
            if (PatientData[row].TATDelay == "1") {
                MyStr = MyStr + '<img title="TATDelay" src="../../images/tatdelay.gif" />';
            }
            if (PatientData[row].CombinationSample == "1") {
                MyStr = MyStr + '<img title="CombinationSample" src="../../images/Red.jpg" style="width:13px; Height:13px;border-radius: 10px;"  />';
            }
            if (PatientData[row].Comments != "") {
                MyStr = MyStr + '<img title="Comments" src="../../images/comments.png" style="width:25px;height:25px;" alt="Comments" />';
            }

            if (PatientData[row].SampleLocation != '')
                td.innerHTML = MyStr + '<br/>' + PatientData[row].SampleLocation;
            else
                td.innerHTML = MyStr;

            td.className = PatientData[row].Status;
            return td;
        }
        function EnableBarcode(instance, td, row, col, prop, value, cellProperties) {
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            cellProperties.readOnly = false;
                <%}%>
            td.innerHTML = value;
            td.className = PatientData[row].Status;
            return td;
        }
        function PrintreportRenderer(instance, td, row, col, prop, value, cellProperties) {
            if (PatientData[row].Approved == "1") {
                // var escaped = Handsontable.helper.stringify(value);
                //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
                td.innerHTML = '<a href="labreportmicro.aspx?IsPrev=1&TestID=' + PatientData[row].Test_ID + ',&Phead=0" target="_blank" > <img  src="../../images/print.gif" style="border-style: none" alt="">     </a>';
                //  td.id = value.replace(/,/g, "_");
            }
            else {
                td.innerHTML = '<span>&nbsp;</span>';
            }
            td.className = PatientData[row].Status;
            return td;
        }

        function SampleIconRenderer(instance, td, row, col, prop, value, cellProperties) {


            var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            td.innerHTML = '<a target="_blank" id="aa" href="SampleCollectionPatient.aspx?LedgerTransactionNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../images/Sample.png" style="border-style: none" alt="">     </a>';
            //td.id = value.replace(/,/g, "_");
            // td.style.background = PatientData[row].Status;
            return td;
        }
        function RemarksFieldRenderer(instance, td, row, col, prop, value, cellProperties) {
            // var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            //  td.innerHTML = '<a target="_blank" id="cc" class="iframe Remark" href="../OPD/AddRemarks_PatientTestPopup.aspx?TestID=' + PatientData[row].Test_ID + '&Name=' + PatientData[row].PName + '&LabNo=' + PatientData[row].LedgerTransactionNo + '"  > <img  src="../../App_Images/edit.png" style="border-style: none" alt="">     </a>';
            //td.id = value.replace(/,/g, "_");
            td.innerHTML = '<input type="text"  autocomplete="off" onkeydown="SaveRemarksStatus(event,this);" id="' + PatientData[row].Test_ID + '#' + PatientData[row].LedgerTransactionNo + '" heght="150px;" value="' + PatientData[row].RemarkStatus + '">';
            td.className = PatientData[row].Status;
            return td;
        }

        function CallFancyBox() {
            //$(".various").fancybox();
            //$(".Remark").fancybox();
            //$("#btnPatientDetail").click(function () {
            //    //$("#various2").attr('href', 'PatientSampleinfoPopup.aspx?TestID=' + PatientData[currentRow].Test_ID + '&LabNo=' + PatientData[currentRow].LedgerTransactionNo);
            //    //$("#various2").fancybox({
            //    //    maxWidth: 1360,
            //    //    maxHeight: 1200,
            //    //    fitToView: false,
            //    //    width: '100%',
            //    //    height: '90%',
            //    //    autoSize: false,
            //    //    closeClick: false,
            //    //    openEffect: 'none',
            //    //    closeEffect: 'none',
            //    //    'type': 'iframe'
            //    //}
            //    //);
            //    //$("#various2").trigger('click');
            //    serverCall('MachineResultEntry.aspx/Bindsampleinfo', { LedgerTransactionNo: PatientData[currentRow].LedgerTransactionNo, Test_ID: PatientData[currentRow].Test_ID }, function (response) {
            //        var data = JSON.parse(response);
            //        var dtdetail = data.SampleInfodt;
            //        var grvAtt = "";
            //        $('#grdTestDetails tr').slice(1).remove();
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblLabNo').text(dtdetail[0]["LedgerTransactionNo"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblSampleType').text(dtdetail[0]["SampleType"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblpname').text(dtdetail[0]["PName"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblAge').text(dtdetail[0]["Age"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblMobile').text(dtdetail[0]["Mobile"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblDepartment').text(dtdetail[0]["DepartmentName"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblRefDoctor').text(dtdetail[0]["ReferDoctor"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblpanel').text(dtdetail[0]["Panel_Code"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblComments').text(dtdetail[0]["Comments"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblVial').text(dtdetail[0]["BarcodeNo"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_lblBedDetails').text(dtdetail[0]["BedDetails"]);
            //        $('#ctl00_ContentPlaceHolder1_popupctrl_llbob').text(dtdetail[0]["DOB"]);
            //        for (var i = 0; i < dtdetail.length; i++) {
            //            grvAtt += '<tr>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].name + '</td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].HomeCollectionDate + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].WorkOrderBy + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].SegratedDate + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].SampleCollector + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].SampleReceiveDate + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].SampleReceivedBy + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].RejectDate + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].RejectUser + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].RejectionReason + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].ResultEnteredDate + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].ResultEnteredName + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].ApprovedDate + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].ApprovedName + '  </td>';
            //            grvAtt += '<td scope="col" style="display:none;">' + dtdetail[i].ApprovedDoneBy + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].holdByName + '  </td>';
            //            grvAtt += '<td scope="col">' + dtdetail[i].Hold_Reason + '  </td>';
            //            grvAtt += '</tr>';
            //        }
            //        $('#grdTestDetails').append(grvAtt);
            //    });
            //    $('#PatientSampleinfoPopup').show();
            //});

            $("a.various").fancybox({
                maxWidth: 1000,
                maxHeight: 600,
                fitToView: false,
                width: '94%',
                height: '70%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });


            $("a.Remark").fancybox({
                maxWidth: 860,
                maxHeight: 600,
                fitToView: false,
                width: '70%',
                height: '70%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
            $("a.PatientDetail").fancybox({
                maxWidth: 860,
                maxHeight: 600,
                fitToView: false,
                width: '70%',
                height: '70%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
            $("a.ShowAttachment").fancybox({
                maxWidth: 860,
                maxHeight: 600,
                fitToView: false,
                width: '70%',
                height: '70%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
            //$('#fancybox-content').css('padding-top', '15px');
            $('#fancybox-content').css('height', '500px');
            $('#fancybox-content').css('overflow-y', 'auto');

        }
        function ManageSampleStatus(row) {
            window.open('SampleCollectionPatient.aspx?LedgerTransactionNo=' + PatientData[row].LedgerTransactionNo, '_blank')
        }
        function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {
            //debugger;
                 <%if (Util.GetString(Request.QueryString["cmd"]) != "changebarcode")
                   {%>
            var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            //td.innerHTML = '<a href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> <img  src="../../App_Images/Post.gif" style="border-style: none" alt="">     </a>';
            td.innerHTML = '<a style="font-weight:bold;" href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> ' + PatientData[row].BarcodeNo + '     </a>';
            td.id = value;//.replace(/,/g, "_");
            //td.style.backgroundColor = "none";
            $(td).addClass(cellProperties.className);
                <%}
                   else
                   {%>
            td.innerHTML = PatientData[row].LedgerTransactionNo;
                <%}%>
            return td;
        }
        function safeTestRenderer(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            td.innerHTML = '<span title="' + value + '" style="overflow: hidden;text-overflow: ellipsis;position: absolute;left: 0; right: 0;">' + value + '</span>';
            //td.id = value.replace(/,/g, "_");
            td.style.width = '200px';
            td.style.position = 'relative';
            $(td).addClass(cellProperties.className);
            return td;
        }
        function setHidden(instance, td, row, col, prop, value, cellProperties) {
            td.hidden = true;
            return td;
        }
        function ExitFullScreen() {
            $('#divInvestigation').removeClass('horizontal');
            $('#divInvestigation').addClass('vertical');
            $('#divPatient').removeClass('horizontal');
            $('#divPatient').addClass('vertical');
        }
        var rowIndx = "";
        function PickRowData(rowIndex) {
            rowIndx = rowIndex;
            //$("#divPatient tr > td").css("background", "#ffffff");
            //$("#divPatient tr:nth-child(" + (rowIndex+1) + ") > td").css("background", "rgb(189, 245, 245)");
            //ExitFullScreen();
            currentRow = rowIndex;
            // hot1.selectCell(currentRow + 1, 0);
            // hot1.selectCell(currentRow, 0);
            //console.log(rowIndex + 1);
            $('#MainInfoDiv').show();
            $('#divPatient').hide();
            _test_id = PatientData[rowIndex].Test_ID;
            _barcodeno = PatientData[rowIndex].BarcodeNo;
            searchLabObservation(rowIndex, PatientData[rowIndex].PName, PatientData[rowIndex].Age_Gender, PatientData[rowIndex].LedgerTransactionNo, PatientData[rowIndex].Test_ID, PatientData[rowIndex].Gender, PatientData[rowIndex].AGE_in_Days,$('#<%=ddlreportnumber.ClientID%>').val());
        }
        function PicSelectedRow() {
            PickRowData(rowIndx);
        }

        function PreLabObs() {
            var minRows = 0;
            if (currentRow > minRows) {
                PickRowData(currentRow - 1);

            }
            else { $('#btnPreLabObs').attr("disabled", true); }
        }
        function NextLabObs() {
            var totalRows = PatientData.length - 1;

            //console.log(totalRows + '/' + currentRow);
            if (totalRows > currentRow) {

                PickRowData(currentRow + 1);
                //hot1.selectCell(currentRow, 1);
            }
            else { $('#btnNextLabObs').attr("disabled", true); modelAlert('No more rows available'); }
        }
        function searchLabObservation(_index, pname, age_gender, labNo, testId, gender, ageInDays,reportnumber) {
            $('.demo').attr('disabled', true);
            var macId = $('#<%=ddlTestDon.ClientID %> option:selected').val();
                LedgerTransactionNo = labNo;
                LoadInvName(LedgerTransactionNo);
                $('#SelectedPatientinfo').html('');
                $('#SelectedPatientinfo').append('' +
                    '<table><tr><th>Barcode No:</th><td>' + PatientData[_index].BarcodeNo + '</td><th>Patient Name:</th><td>' + pname + '</td><th>Age/Gender:</th><td>' + age_gender + '</td></tr>' +
                    '</table>');
                $('#divInvestigation').html('');
                $.ajax({
                    url: "MachineResultEntry_Culture.aspx/LabObservationSearch",
                    data: '{LabNo:"' + labNo + '",TestID:"' + testId + '",AgeInDays:' + ageInDays + ',RangeType:"Normal",Gender:"' + gender + '",MachineID:"' + $('#<%=ddlMachine.ClientID%>').val() + '",macId:"' + macId + '",reportnumber:"' + reportnumber + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    renderAllRows: true,
                    mergeCells: true,
                    success: function (result) {
                        $('.SampleStatus').hide();

                        $('#btnPreLabObs').attr("disabled", false);
                        $('#btnNextLabObs').attr("disabled", false);
                        LabObservationData = $.parseJSON(result.d);

                        if (LabObservationData == "-1") {
                            $('.btnForSearch').attr("disabled", true);
                         //   $.unblockUI();
                            modelAlert('Your Session Expired.... Please Login Again');
                            return;
                        }
                        if (LabObservationData.length == 0) {
                            $('.btnForSearch').attr("disabled", true);
                         //   $.unblockUI();
                            $("#<%=lblMsg.ClientID %>").text('No Record Found');
                            return;
                        }
                        else {
                           
                            UpdateSampleStatus(LabObservationData[0].mystatus);
//console.log(LabObservationData[0].mystatus);
                            $('#divantibody').hide();
                            $('#AntiBioTicList tr').slice(1).remove();

                            $('.demo').attr('disabled', false);
                            $('.SampleStatus').attr('disabled', false);
                            $("#<%=lblMsg.ClientID %>").text('');

                            var data = LabObservationData,
                             container2 = document.getElementById('divInvestigation');
                            hot2 = new Handsontable(container2, {
                                data: LabObservationData,
                                colHeaders: [
                                     "Test", "Value","Unit", "Comment"
                                ],
                                columns: [
                                { data: 'LabObservationName', readOnly: false, renderer: LabObservationRender, width: 200 },
                                { data: 'Value', readOnly: false, renderer: CheckCellValue, width: 100 },
                                { data: 'ReadingFormat', readOnly: false },
                                { renderer: ShowComment },



                                ],
                                stretchH: "all",
                                autoWrapRow: false,
                                manualColumnFreeze: true,
                                rowHeaders: true,
                                readOnly: true,
                                fillHandle: false,
                                rowHeaders: false,
                                beforeChange: function (change, source) {
                                    updateFlag(change);

                                },

                                cells: function (row, col, prop) {

                                    if (LabObservationData[row].IsComment == "0") {
                                        if (prop === 'Value' && LabObservationData[row].Help != "" && LabObservationData[row].Approved == "0") {
                                            var val = LabObservationData[row].Value;
                                            var helpArr = [];
                                            var helpDropDown = [];
                                            try {
                                                helpArr = LabObservationData[row].Help.split('|');
                                                for (var i = 0; i < helpArr.length; i++) {
                                                    var arr = [];
                                                    arr = helpArr[i].split('#');
                                                    helpDropDown.push(arr[0]);
                                                }
                                                this.type = 'autocomplete';
                                                this.source = helpDropDown;
                                                this.strict = false;
                                            }
                                            catch (e) {
                                            }
                                        }


                                    }
                                    else if (LabObservationData[row].IsComment == "1") {
                                        this.readOnly = true;
                                    }

                                    if (prop === 'Value' && LabObservationData[row].LabObservationName == "MicroScopy") {
                                        this.type = 'dropdown';
                                        this.source = ['Wet Mount', 'Gram Stain', 'AFB Stain', 'Other'];
                                        //if (elt.options[elt.selectedIndex].text == "Approved" || elt.options[elt.selectedIndex].text == "Printed" || LabObservationData[row].IsSampleCollected != 'Y') {
                                        //    this.readOnly = true;
                                        //}
                                        //else {
                                        //    this.readOnly = false;
                                        //}

                                    }

                                    if (LabObservationData[row].Inv == "3") {
                                        this.readOnly = true;
                                    }



                                }
                            });
                            ApplyFormula();
                            hot2.selectCell(0, 1);

                         //   $.unblockUI();
                            $('.btnForSearch').attr("disabled", false);
                          
                            $('#<%=txtindate.ClientID%>').val(LabObservationData[0].incubationdate);
                            $('#<%=txtintime.ClientID%>').val(LabObservationData[0].incubationtime);

                            //console.log(LabObservationData[0].micro);

                            showantibiotic(LabObservationData[0].micro);


                        }
                    },
                    error: function (xhr, status) {
                   //     $.unblockUI();
                        $('#divInvestigation').html('');
                        modelAlert('Please Contact to Administrator Support Team');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        function checkDate(sender, args) {
            if (sender._selectedDate <= new Date()) {
                modelAlert("You cannot select a day earlier than today!");
                sender._selectedDate = new Date();
                // set the date back to the current date
            
                $('#<%=txtindate.ClientID%>').val(sender._selectedDate.format(sender._format));
            }
        }
            function LoadInvName(LabNo) {
                $.ajax({
                    url: "MachineResultEntry_Culture.aspx/GetPatientInvsetigationsNameOnly",
                    data: '{ LabNo:"' + LabNo + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        InvData = result.d;
                        $('.DivInvName').html(InvData);
                        $('.DivInvName').show();
                    },
                    error: function (xhr, status) {
                        modelAlert("Error.... ");
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            function LabObservationRender(instance, td, row, col, prop, value, cellProperties) {

                if (LabObservationData[row].Inv == "1") {
                    if (LabObservationData[row].IsAttached != "") {
                        td.innerHTML = value + '<br/>' + LabObservationData[row].IsAttached;
                    }
                    else {

                        td.innerHTML = value;
                    }
                }

                else {
                    td.innerHTML = value;
                }
                td.style.background = LabObservationData[row].Status;
                td.style.width = '200px';

                if (LabObservationData[row].Inv == "1") {
                    $(td).parent().addClass('InvHeader');
                    //console.log(LabObservationData[row].Test_ID);
                    //console.log(LabObservationData[row].LabNo);
                    td.innerHTML += '<img  src="../../images/ButtonAdd.png" style="cursor:pointer;" alt="" onclick="AddRemarksOnpopup(\'' + LabObservationData[row].LedgerTransactionNo + '\',\'' + LabObservationData[row].Test_ID + '\',\'' + LabObservationData[row].LabObservationName + '\')">';
                }
                else if (LabObservationData[row].Inv == "3") {
                    $(td).parent().addClass('DeptHeader');
                }
                else if (LabObservationData[row].Inv == "2") {


                }

                if (LabObservationData[row].Value == "HEAD") {
                    $(td).parent().addClass('InvSubHead');
                }
                cellProperties.readOnly = true;
                return td;
            }
            function CheckCellValue(instance, td, row, col, prop, value, cellProperties) {
                //debugger;
                
                if ((LabObservationData[row].Inv == "1") || (LabObservationData[row].Inv == "3")) {
                    cellProperties.readOnly = true;
                    td.innerHTML = '';

                    return td;
                }
                else if (LabObservationData[row].Inv == "4") {
                    cellProperties.readOnly = true;
                    if (LabObservationData[row].LabObservationName == "Attached Report") {
                        td.innerHTML = '<img  src="../../images/view.GIF" style="cursor:pointer;" alt="" onclick="ViewDocument(\'' + value + '\')">';
                        cellProperties.readOnly = true;
                    }
                    else {
                        td.innerHTML = value;
                    }
                    return td;
                }
                else if (LabObservationData[row].Inv == "2") {
                    //if (elt.options[elt.selectedIndex].text == "Approved" || elt.options[elt.selectedIndex].text == "Printed" || LabObservationData[row].IsSampleCollected != 'Y') {
                    //    cellProperties.readOnly = true;
                    //}
                    //else {
                    //    cellProperties.readOnly = false;
                    //}
                    td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../images/ButtonAdd.png"/></span>';
                    return td;
                }

                if (LabObservationData[row].IsComment == "0") {

                    if (value == 'HEAD' || MYSampleStatus == "Approved" || MYSampleStatus == "Printed" || LabObservationData[row].IsSampleCollected != 'Y') {
                        cellProperties.readOnly = true;
                    } else {
                        cellProperties.readOnly = false;
                    }
                    td.innerHTML = value;
                }
                else if (LabObservationData[row].IsComment == "1") {

                    if (LabObservationData[row].Value == "")
                        td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../images/ButtonAdd.png"/></span>';
                    if (LabObservationData[row].Value != "")
                        td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../images/Redplus.png"/></span>';
                }
                if (LabObservationData[row].LabObservationName == "ORGANISM")//organism page
                {
                    td.innerHTML = '<img  src="../../images/edit.png" style="border-style: none;cursor:pointer;" alt="" onclick="viewobsdata()">';
                    cellProperties.readOnly = true;
                }
              
                    //td.innerHTML = '<a target="_blank" id="cc" class="iframe Remark" href="LabResultEntryNew_Micro.aspx?TestID=' + LabObservationData[row].Test_ID + '&LabNo=' + LabObservationData[row].LabNo + '&InvId=' + LabObservationData[row].Investigation_ID + '"  > <img  src="../../App_Images/edit.png" style="border-style: none" alt="">     </a>';
                    //td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../images/ButtonAdd.png"/></span>';
                else if (LabObservationData[row].ReportType != "1") {
                    td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../images/ButtonAdd.png"/></span>';

                }
                return td;
            }
            function ViewDocument(url) {
                //debugger;
                var url1 = "\\LABINVESTIGATION\\OutSourceLabReport\\" + url;
                //alert(url1);
                window.open("ViewFile.aspx?FileUrl=" + url1 + "&Extension=pdf");
            }
          
            function changeColor(instance, td, row, col, prop, value, cellProperties) {


                if (LabObservationData[row].Inv > 0) {
                    td.innerHTML = value;
                    return td;
                }


                isRed = 0;
                var MinRange = LabObservationData[row].MinValue;
                var MaxRange = LabObservationData[row].MaxValue;
                var Value = LabObservationData[row].Value;
                if (Value == "") {
                    LabObservationData[row].Flag = '';
                    value = '';
                }
                else {
                    if (MinRange != "") {
                        if (parseFloat(Value) < parseFloat(MinRange)) {
                            isRed = 1;
                            LabObservationData[row].Flag = 'Low';
                            value = 'Low';
                        }
                        else {
                            LabObservationData[row].Flag = 'Normal';
                            value = 'Normal';
                        }
                    }

                    if (isRed == 0 && MaxRange != "") {
                        if (parseFloat(Value) > parseFloat(MaxRange)) {

                            LabObservationData[row].Flag = 'High';
                            value = 'High';
                        }
                        else {
                            LabObservationData[row].Flag = 'Normal';
                            value = 'Normal';
                        }
                    }
                }
                if (value == "Low") {
                    td.style.background = 'rgb(251, 255, 0)';
                    $(td).parent().addClass('FullRowColorInYellow');
                }
                else if (value == "High") {
                    td.style.background = 'pink';
                    $(td).parent().addClass('FullRowColorInPink');
                }
                td.innerHTML = value;

                return td;
            }


            function viewobsdata() {
                $('#divantibody').show();

            }

            function ShowComment(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
                if (LabObservationData[row].ReportType == "1" && LabObservationData[row].IsComment == "1") {
                    td.innerHTML = '';
                }
                else if (LabObservationData[row].ReportType != "1") {
                    td.innerHTML = '';
                }
                else if (LabObservationData[row].LabObservationName == "Organism Tables")
                    td.innerHTML = '';
                else if (LabObservationData[row].Value == "HEAD")
                    td.innerHTML = '';
                else {
                    td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', ' + prop + ',' + value + ');"><img src="../../images/ButtonAdd.png"/></span>';
                }
                return td;
            }
            function ShowModalWindow(row, col, prop, value) {
             
               // CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData('');
                //console.log(LabObservationData[row].Description);
                if (prop != "Value") {
                    $('#CommentHead').html('Comments');
                    $('#CommentBox').show();
                    CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                    $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                    $('#DIVMODELFOOTER').html('<h3 style="height: 20px;">' +
                        '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                        '<div style="float: right;">' +
                        '&nbsp;&nbsp;&nbsp;<input type="button" value="Add Comment" onclick="AddComment(' + row + ',' + prop + ');" class="btnAddComment" style="height: 30px;"/>' +
                        '&nbsp;&nbsp;&nbsp;<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                        '</div></h3>');
                    modal.style.display = "block";

                    loadObservationComment(row, col, prop, value);
                } else if (prop == "Value") {

                    if (LabObservationData[row].ReportType == "1") {
                        
                        $('#CommentHead').html('Comments');
                        $('#CommentBox').show();
                        CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                    $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                    $('#DIVMODELFOOTER').html('<h3 style="height: 20px;">' +
                        '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                        '<div style="float: right;">' +
                        '&nbsp;&nbsp;&nbsp;<input type="button" value="Add Comment" onclick="AddComment(' + row + ',' + prop + ');" class="btnAddComment" style="height: 30px;"/>' +
                        '&nbsp;&nbsp;&nbsp;<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                        '</div></h3>');
                    modal.style.display = "block";

                    }
                    else if (LabObservationData[row].ReportType == "3" || LabObservationData[row].ReportType == "5") {
                      
                        $('#CommentHead').html('Templates');
                        $('#CommentBox').show();
                        CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                        $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                        $('#DIVMODELFOOTER').html('<h3 style="height: 20px;">' +
                            '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                            '<div style="float: right;">' +
                            '&nbsp;&nbsp;&nbsp;<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                            '&nbsp;&nbsp;&nbsp;<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                            '</div></h3>');

                        BindTemplateValue(row, col, prop, value);


                        loadObservationComment(row, col, prop, value);
                    }
                    else  {

                        $('#CommentHead').html('Comment');
                        $('#CommentBox').show();
                        CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                        $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                        $('#DIVMODELFOOTER').html('<h3 style="height: 20px;">' +
                            '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                            '<div style="float: right;">' +
                            '&nbsp;&nbsp;&nbsp;<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                            '&nbsp;&nbsp;&nbsp;<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                            '</div></h3>');

                    }

                modal.style.display = "block";
            }
    }
    function BindTemplateValue(row, col, prop, value) {
        if (LabObservationData[row].Method == 1)
            return;
        $.ajax({
            url: "MachineResultEntry_Culture.aspx/Getpatient_labobservation_opd_text",
            data: '{ TestId:"' + LabObservationData[row].LabObservation_ID + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                LabObservationData[row].Method = 1;
                LabObservationData[row].Description = result.d;
                CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(result.d);
            },
            error: function (xhr, status) {
                modelAlert("Error.... ");
            }
        });
    }
    function loadObservationComment(row, col, prop, value) {
        $('#ddlCommentsLabObservation').attr('title', prop);
        $.ajax({

            url: "MachineResultEntry_Culture.aspx/Comments_LabObservation",
            data: '{ LabObservation_ID:"' + LabObservationData[row].LabObservation_ID + '",Type:"' + prop + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                result = $.parseJSON(result.d);
                $("#ddlCommentsLabObservation").empty();
                $("#ddlCommentsLabObservation").append("<option value=''>Select</option>");
                if (prop == 'Value') {
                    for (var i = 0; i < result.length; i++) {
                        var newOption = "<option value=" + result[i].Template_ID + ">" + result[i].Temp_Head + "</option>";
                        $("#ddlCommentsLabObservation").append(newOption);
                    }
                }
                else {
                    for (var i = 0; i < result.length; i++) {
                        var newOption = "<option value=" + result[i].Comments_ID + ">" + result[i].Comments_Head + "</option>";
                        $("#ddlCommentsLabObservation").append(newOption);
                    }
                }
            },
            error: function (xhr, status) {
                modelAlert("Error.... ");
            }
        });

    }


    function ddlCommentsLabObservation_Load(CommentID) {
        var type = $('#ddlCommentsLabObservation').attr('title');
        $.ajax({
            url: "MachineResultEntry_Culture.aspx/GetComments_labobservation",
            data: '{ CmntID:"' + CommentID + '",type:"' + type + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(result.d);
            },
            error: function (xhr, status) {
                modelAlert("Error.... ");
            }
        });

        }

        function ClearComment() {
            CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData('');
        }
        function CancelComment() {
            modal.style.display = "none";
        }
        function AddComment(rowValue, prop) {
            var commentValue = CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].getData();
            LabObservationData[rowValue].Description = commentValue;
            LabObservationData[rowValue].Value = commentValue;
            if (LabObservationData[rowValue].IsComment == 1) {
                LabObservationData[rowValue].Description = commentValue;
                LabObservationData[rowValue].Value = 'Reported';

            }
            modal.style.display = "none";
        }
        var isRed = 0;
        function updateFlag(change) {
            var myarr = [];
            myarr = change;
            isRed = 0;
            if (myarr != null) {
                var row = change[0][0];
                var col = change[0][1];
                var old = change[0][2];
                var newvalue = change[0][3];

                var MinRange = LabObservationData[row].MinValue;
                var MaxRange = LabObservationData[row].MaxValue;
                var Value = newvalue;
                if (col == 'Value') { LabObservationData[row].Value = newvalue; }
                else if (col == 'MinValue') { LabObservationData[row].MinValue = newvalue; }
                else if (col == 'MaxValue') { LabObservationData[row].MaxValue = newvalue; }
                else if (col == 'PrintMethod') { LabObservationData[row].PrintMethod = newvalue; }
                else if (col == 'ReadingFormat') { LabObservationData[row].ReadingFormat = newvalue; }
                else if (col == 'Flag') { LabObservationData[row].Flag = newvalue; }
                if (col == 'Value') {
                    if (isNaN(newvalue) || newvalue == "" || newvalue == "HEAD") {
                        LabObservationData[row].Flag = '';
                    }
                    else {
                        if (MinRange != "") {
                            if (parseFloat(Value) < parseFloat(MinRange)) {
                                isRed = 1;
                                LabObservationData[row].Flag = 'Low';
                            }
                            else {
                                LabObservationData[row].Flag = 'Normal';
                            }
                        }

                        if (isRed == 0 && MaxRange != "") {
                            if (parseFloat(Value) > parseFloat(MaxRange)) {
                                LabObservationData[row].Flag = 'High';
                            }
                            else {
                                LabObservationData[row].Flag = 'Normal';
                            }
                        }
                        ApplyFormula();
                    }
                }
            }
        }
        function ApplyFormula() {

            for (var i = 0; i < LabObservationData.length; i++) {
                if (LabObservationData[i].Inv == '0') {
                    //console.log(LabObservationData[i].LabObservation_ID.Value);
                    LabObservationData[i].isCulture = LabObservationData[i].Formula;
                    // LabObservationData[i].isCulture=LabObservationData[i].isCulture.replace((LabObservationData[i].LabObservation_ID+"@"),LabObservationData[i].Value);
                    //alert(LabObservationData[i].isCulture);

                    if (LabObservationData[i].isCulture != '') {
                        for (var j = 0; j < LabObservationData.length; j++) {
                            try {
                                if (LabObservationData[j].Inv == '0')
                                    LabObservationData[i].isCulture = LabObservationData[i].isCulture.replace(new RegExp("#" + (LabObservationData[j].LabObservation_ID + "@"), 'g'), LabObservationData[j].Value);
                            }
                            catch (e) {
                            }

                        }

                        try {
                            LabObservationData[i].Value = Math.round(eval(LabObservationData[i].isCulture) * 100) / 100;
                        } catch (e) { LabObservationData[i].Value = '' }
                        var ans = LabObservationData[i].Value;
                        if ((isNaN(ans)) || (ans == "Infinity") || (ans == 0)) {
                            LabObservationData[i].Value = '';
                        }

                    }
                }
            }
        }
        function UnForward() {
            resultStatus = "Un Forward";
            SaveLabObs();
        }

        function Forward() {
            //resultStatus = "Forward";

            $("#<%=ddltest.ClientID %> option").remove();
            var ddlTest = $("#<%=ddltest.ClientID %>");
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/BindTestToForward",
                data: '{ testid: "' + PatientData[currentRow].Test_ID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    Tdata = $.parseJSON(result.d);
                    for (i = 0; i < Tdata.length; i++) {

                        ddlTest.append($("<option></option>").val(Tdata[i]["test_id"]).html(Tdata[i]["name"]));
                    }
                    ddlTest.chosen();
                    ddlTest.trigger('chosen:updated');
                    $('#ctl00_ContentPlaceHolder1_ddltest_chosen').css("width", "200px");
                   // ddlTest.chosen();
                },
                error: function (xhr, status) {



                }
            });


            $("#<%=ddlcentre.ClientID %> option").remove();
            var ddlcentre = $("#<%=ddlcentre.ClientID %>");
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/BindCentreToForward",
                data: '{}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    Cdata = $.parseJSON(result.d);
                    for (i = 0; i < Cdata.length; i++) {

                        ddlcentre.append($("<option></option>").val(Cdata[i]["centreid"]).html(Cdata[i]["centre"]));
                    }
                    ddlcentre.chosen();
                    ddlcentre.trigger('chosen:updated');
                    $('#ctl00_ContentPlaceHolder1_ddlcentre_chosen').css("width", "200px");
                },
                error: function (xhr, status) {



                }
            });

            binddoctoforward();

          //  $find('ModalPopupExtender2').show();
            $('#ModalPopupExtender2').show();
            //SaveLabObs();
        }

        function binddoctoforward() {
            $("#<%=ddlforward.ClientID %> option").remove();
            var ddlforward = $("#<%=ddlforward.ClientID %>");
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/BindDoctorToForward",
                data: '{centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    Fdata = $.parseJSON(result.d);
                    for (i = 0; i < Fdata.length; i++) {

                        ddlforward.append($("<option></option>").val(Fdata[i]["employeeid"]).html(Fdata[i]["Name"]));
                    }
                    ddlforward.chosen();
                    ddlforward.trigger('chosen:updated');
                    $('#ctl00_ContentPlaceHolder1_ddlforward_chosen').css("width", "200px");
                },
                error: function (xhr, status) {

                }
            });
        }
        function Forwardme() {


            var length1 = $('#<%=ddltest.ClientID %>  option').length;
            if ($("#<%=ddltest.ClientID %> option:selected").val() == "" || length1 == 0) {
                //$('#msgField').html('');
                //$('#msgField').append("Please Select Test");
                //$(".alert").css('background-color', 'red');
                //$(".alert").removeClass("in").show();
                //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                $("#<%=ddltest.ClientID %>").focus();
                modelAlert('Please Select Test');
                return;
            }
            var length2 = $('#<%=ddlcentre.ClientID %>  option').length;
            if ($("#<%=ddlcentre.ClientID %> option:selected").val() == "" || length2 == 0) {
                //$('#msgField').html('');
                //$('#msgField').append("Please Select Centre");
                //$(".alert").css('background-color', 'red');
                //$(".alert").removeClass("in").show();
                //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                modelAlert('Please Select Centre');
                $("#<%=ddlcentre.ClientID %>").focus();
                return;
            }

            var length3 = $('#<%=ddlforward.ClientID %>  option').length;


            if ($("#<%=ddlforward.ClientID %> option:selected").val() == "" || length3 == 0) {
                //$('#msgField').html('');
                //$('#msgField').append("Please Select Doctor to Forward");
                //$(".alert").css('background-color', 'red');
                //$(".alert").removeClass("in").show();
                //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                modelAlert('Please Select Doctor to Forward');
                $("#<%=ddlforward.ClientID %>").focus();
                return;
            }


            $.ajax({
                url: "MachineResultEntry_Culture.aspx/ForwardMe",
                data: '{testid:"' + $('#<%=ddltest.ClientID%> option:selected').val() + '" ,centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '",forward:"' + $('#<%=ddlforward.ClientID%> option:selected').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                       // $('#msgField').html('');
                       // $('#msgField').append("Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text());
                       // $(".alert").css('background-color', '#04b076');
                       // $(".alert").removeClass("in").show();
                       // $(".alert").delay(1500).addClass("in").fadeOut(1500);
                        modelAlert("Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text())
                      //  $find('ModalPopupExtender2').hide();
                        $('#ModalPopupExtender2').hide();
                        var totalRows = PatientData.length - 1;
                        if (totalRows > currentRow) {

                            PickRowData(currentRow + 1);

                        }
                        else {
                            PickRowData(currentRow);
                        }

                    }
                    else {
                        //$('#msgField').html('');
                        //$('#msgField').append(result.d);
                        //$(".alert").css('background-color', 'red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1500);
                        modelAlert(result.d);

                    }
                },
                error: function (xhr, status) {



                }
            });

        }
        function NotApproved() {
            $('#<%=txtnotappremarks.ClientID%>').val('');
           // $find('mpnotapprovedrecord').show();
            $('#pnlnotapproved').show();
           $('#<%=txtnotappremarks.ClientID%>').focus();

           //resultStatus = "Not Approved";
           //SaveLabObs();
        }

        function NotApprovedFinaly() {
            if ($('#<%=txtnotappremarks.ClientID%>').val() == "") {
                $('#<%=txtnotappremarks.ClientID%>').focus();
                modelAlert("Please Enter Not Approved Remarks");
                return;
            }
          //  $find('mpnotapprovedrecord').hide();
            $('#pnlnotapproved').hide();
            resultStatus = "Not Approved";
            SaveLabObs();

        }

        //function modelAlert(msg) {
        //    //$('#msgField').html('');
        //    //$('#msgField').append(msg);
        //    //$(".alert").css('background-color', 'red');
        //    //$(".alert").removeClass("in").show();
        //    //$(".alert").delay(1500).addClass("in").fadeOut(1000);
        //    modelAlert(msg);
        //}
        function Approved() {

            //viewremarks();
            resultStatus = "Approved";
            SaveLabObs();
        }
        function Preliminary() {
            resultStatus = "Preliminary Report";
            SaveLabObs();
        }
        function Save() {
            resultStatus = "Save";
            SaveLabObs();
        }
        function UnHold() {
            resultStatus = "UnHold";
            SaveLabObs();
        }
        function Hold() {
            // $find('mpHoldRemarks').show();
            $('#pnlHoldRemarks').show();
        }


        function onKeyDown(e) {
            //if (e && e.keyCode == Sys.UI.Key.esc) {
            //    if ($find('mpHoldRemarks')) {
                    closeHoldRemarks();
            //    }
            //}
        }


        function closeHoldRemarks() {
            $("#txtHoldRemarks").val('');
           // $find('mpHoldRemarks').hide();
            $('#pnlHoldRemarks').hide();
            $("#spnHoldRemarks").text('');
            $("#btnHoldRemarks").removeAttr('disabled').val('Save');
        }
        function saveHoldRemarks() {
            if ($.trim($("#txtHoldRemarks").val()) != "") {
                $("#btnHoldRemarks").attr('disabled', 'disabled').val('Submitting...');
                resultStatus = "Hold";
                SaveLabObs();
                $("#spnHoldRemarks").text('');
            }
            else {
                $("#spnHoldRemarks").text('Please Enter Remarks');
                modelAlert('Please Enter Remarks');
                $("#txtHoldRemarks").focus();
            }

        }


        function SaveApproved() {

            if ($('#<%=ddlapptype.ClientID%> option:selected').text() == 'Select') {

                modelAlert("Please Select Approval Type");
                $('#<%=ddlapptype.ClientID%>').focus();
                return;
            }

            if ($('#<%=ddlapptype.ClientID%> option:selected').text() == "Final") {
                resultStatus = "Approved";
            }
            else {
                resultStatus = "InterimApproved";
            }

            SaveLabObs();
            unloadPopupBox();

        }
        function viewremarks() {


            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });

        }
        function unloadPopupBox() {    // TO Unload the Popupbox

            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({ // this is just for style        
                "opacity": "1"
            });
        }


        function SaveLabObs() {
            var antibioticdatetosave = antibioticdate();

            var reportnumber = $('#<%=ddlreportnumber.ClientID%>').val();

            var notapprovalcomment = "";

            if (resultStatus == "Not Approved")
                notapprovalcomment = $.trim($("#<%=txtnotappremarks.ClientID%>").val());

            var HoldRemarks = "";
            if (resultStatus == "Hold")
                HoldRemarks = $.trim($("#txtHoldRemarks").val());


            $.ajax({
                url: "MachineResultEntry_Culture.aspx/SaveLabObservationOpdData",
                //string ApprovedBy,string ApprovalName
                data: JSON.stringify({ reportnumber: reportnumber, antibioticdata: antibioticdatetosave, data: LabObservationData, ResultStatus: resultStatus, ApprovedBy: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%>').val() : ''), ApprovalName: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%> :selected').text() : ''),HoldRemarks: HoldRemarks,notapprovalcomment: notapprovalcomment }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    if (result.d == 'success') {
                        modelAlert('Record Saved Successfully', function (response) {
                        //$('#msgField').html('');
                        //$('#msgField').append('Record Saved Successfully.');
                        //$(".alert").css('background-color', '#04b076');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        var totalRows = PatientData.length - 1;
                        if (totalRows > currentRow) {

                            PickRowData(currentRow + 1);

                        }
                        else {
                            PickRowData(currentRow);
                        }
                        if (resultStatus == "Hold") {
                            closeHoldRemarks();
                            $('#btnApprovedLabObs,#btnholdLabObs').hide();
                            $('#btnUnholdLabObs').show();
                        }
                        else if (resultStatus == "UnHold") {

                            $('#btnApprovedLabObs,#btnholdLabObs').show();
                            $('#btnUnholdLabObs').hide();
                        }
                        else if (resultStatus == "Approved") {
                            $('#btnUnholdLabObs,#btnholdLabObs').hide();


                        }
                    });
                    }
                    else {
                        //$('#msgField').html('');
                        //$('#msgField').append(result);
                        //$(".alert").css('background-color', 'red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        modelAlert(result);
                    }

                },
                error: function (xhr, status) {
                  //  $.unblockUI();
                    var err = eval("(" + xhr.responseText + ")");
                    //$('#msgField').html('');
                    //$('#msgField').append(err.Message);
                    //$(".alert").css('background-color', 'red');
                    //$(".alert").removeClass("in").show();
                    //$(".alert").delay(4000).addClass("in").fadeOut(2000);
                    modelAlert(err.Message);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function PrintReport(IsPrev) {
            window.open('labreportmicro.aspx?IsPrev=' + IsPrev + '&TestID=' + PatientData[currentRow].Test_ID + ',&Phead=0&reportnumber=' + $('#<%=ddlreportnumber.ClientID%>').val());
        }

        function UpdateBarcodes(row, _barcode) {
            //console.log(row);
            var TestID = PatientData[row].Test_ID;
            var LedgerTransactionNo = PatientData[row].LedgerTransactionNo;
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/UpdateLabInvestigationOpdData",
                data: '{ TestID: "' + TestID + '",Barcode:"' + _barcode + '",LedgerTransactionNo:"' + LedgerTransactionNo + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result == "success") {
                        modelAlert('Record Updated Successfully.');
                    }
                    if (result == "duplicate") {
                        modelAlert('Vial ID Already  Exit..');
                    }

                },
                error: function (xhr, status) {
                 //   $.unblockUI();
                    modelAlert('Please Contact to Administrator Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        
        function SearchInvestigation(LabNo) {
         //   $.blockUI();
            $.ajax({
                url: "SampleCollectionPatient.aspx/SearchInvestigation",
                data: '{ LabNo: "' + LabNo + '", SmpleColl:"' + $("#<%=ddlSampleStatus.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = $.parseJSON(result.d);
                    if (PatientData == "-1") {
                    //    $.unblockUI();
                        modelAlert('Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (PatientData.length == 0) {
                     //   $.unblockUI();
                        modelAlert('No Record Found');
                        return;
                    }
                    else {
                        var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                        $('#divInvestigation').html(output);
                        $('.chkSample').each(function () {
                            this.checked = true;
                        });
                      //  $.unblockUI();
                    }
                },
                error: function (xhr, status) {
                  //  $.unblockUI();
                    modelAlert('Please Contact to Administrator Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }


        function SaveSampleCollection(Type) {
            var ItemData = "";
            var BarcodeID = "";
            $("#tb_SearchInvestigations tr").find(':checkbox').filter(':checked').each(function () {
                var TestID = $(this).closest("tr").attr("id");

                var $rowid = $(this).closest("tr");
                if (TestID != "Header") {
                    ItemData += $(this).closest('tr').attr('id') + '#';
                    BarcodeID += $(this).closest('tr').attr('id').split('_')[0] + ',';

                }

            });
            if (ItemData == "") {
                modelAlert("Please Select Sample First..!");
                return;
            }
            //  modelAlert(BarcodeID);
          //  $.blockUI();
            $.ajax({
                url: "SampleCollectionPatient.aspx/SaveSampleCollection",
                data: '{ ItemData:"' + ItemData + '",Type:"' + Type + '"}', // parameter map       
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result == "-1") {
                       // $.unblockUI();
                        modelAlert("Your Session Expired...Please Login Again");

                        return;
                    }
                    if (result == "0") {
                      //  $.unblockUI();
                        modelAlert("Record Not Saved");
                        return;
                    }
                    if (result == "1") {
                      //  $.unblockUI();
                        getBarcode('', BarcodeID);
                        //alert("Record Saved Successfully...");
                        return;
                    }
                },
                error: function (xhr, status) {
                   // $.unblockUI();
                    modelAlert("Please Contact to Administrator Support Team");
                }


            });
        }


        function getBarcode(_LabNo, _Test_ID) {
            $.ajax({
                url: "SampleCollectionPatient.aspx/getBarcode",
                data: '{ LabNo:"' + _LabNo + '",TestID:"' + _Test_ID + '"}', // parameter map       
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result != '')
                        window.location = 'barcode://?test=1&cmd=' + result;
                },
                error: function (xhr, status) {
                    modelAlert("Please Contact to Administrator Support Team");
                }
            });
        }
    </script>


    <script type="text/javascript">
        $(function () {
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }

            $("#ddlInvestigation")
              // don't navigate away from the field on tab when selecting an item
              .bind("keydown", function (event) {
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      $(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  $("#theHidden").val('');
              })
              .autocomplete({

                  source: function (request, response) {
                      $.getJSON("../Common/json.aspx?cmd=investigation", {
                          term: extractLast(request.term)
                      }, response);
                  },
                  search: function () {
                      // custom minLength
                      var term = extractLast(this.value);
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {

                      $("#theHidden").val(ui.item.id)

                      var terms = split(this.value);
                      // remove the current input
                      terms.pop();
                      // add the selected item
                      terms.push(ui.item.value);
                      // add placeholder to get the comma-and-space at the end
                      //terms.push("");
                      this.value = terms;
                      return false;
                  }
              });
        });
        $(function () {
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }

            $("#ddlPanel")
              // don't navigate away from the field on tab when selecting an item
              .bind("keydown", function (event) {
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      $(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  $("#pnlHidden").val('');
              })
              .autocomplete({

                  source: function (request, response) {
                      $.getJSON("../Common/json.aspx?cmd=Panel&CentreId=" + $('#<%=ddlCentreAccess.ClientID%>').val(), {
                          term: extractLast(request.term)
                      }, response);
                  },
                  search: function () {
                      // custom minLength
                      var term = extractLast(this.value);
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {

                      $("#pnlHidden").val(ui.item.id)

                      var terms = split(this.value);
                      // remove the current input
                      terms.pop();
                      // add the selected item
                      terms.push(ui.item.value);
                      // add placeholder to get the comma-and-space at the end
                      //terms.push("");
                      this.value = terms;
                      return false;
                  }
              });
        });
    </script>



    <%-- Micro Saving--%>
    <script type="text/javascript">
        var mouseX;
        var mouseY;
        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });
        function _showhideList(ctr, ctr1) {


            if ($('.helpselect').css('display') == 'none') {
                $('.helpselect').css({ 'top': parseInt(mouseY) + 16, 'left': parseInt(mouseX) - 100 }).show();
                $('.helpselect').attr("id", "help_" + ctr + "_" + ctr1);
                $('.helpselect :first-child').attr('selected', true);
            } else {
                $('.helpselect').hide();
                $('.helpselect').removeAttr("id");
                $('.helpselect').prop('selectedIndex', 0);
            }

        }

        function _showhideList1(myctrl, event, ctr, ctr1) {

            var position = $(myctrl).position();
           
            if (event.keyCode == 13) {
             
              
                if ($('.helpselect').css('display') == 'none') {

                    $('.helpselect').css({ 'top': parseInt(position.top) + 22, 'left': parseInt(position.left) }).show();
                    $('.helpselect').attr("id", "help_" + ctr + "_" + ctr1);
                    $('.helpselect').focus();
                    $('.helpselect :first-child').attr('selected', true);

                } else {
                    $('.helpselect').hide();
                    $('.helpselect').removeAttr("id");
                    $('.helpselect').prop('selectedIndex', 0);
                }
                //$find('ModalPopupExtender2').hide();
                $('#ModalPopupExtender2').hide();

                $find('mpnotapprovedrecord').hide();
            }
        }

        function addtotext(obj) {

            var id = $(obj).attr("id");
            var mm = id.split('_')[1] + '_' + id.split('_')[2];
            $('.' + mm).val($(obj).val());
            $('.' + mm).focus();

            $('.helpselect').hide();
            $('.helpselect').removeAttr("id");
        }

        function addtotext1(obj, event) {
            // $find('ModalPopupExtender2').hide();
            $('#ModalPopupExtender2').show();
            $find('mpnotapprovedrecord').hide();
            if (event.keyCode == 13) {
                
                var id = $(obj).attr("id");
                var mm = id.split('_')[1] + '_' + id.split('_')[2];
                $('.' + mm).val($(obj).val());
                $('.' + mm).focus();

                $('.helpselect').hide();
                $('.helpselect').removeAttr("id");
              
                
            }
        }
        
        


        function AddAntibotic(validation) {
         //   $.blockUI();
            if (validation == "1"){
                if ($('#<%=ddlOrganism.ClientID%>').val() != "0") {

                    if ($('.' + $('#<%=ddlOrganism.ClientID%>').val()).length > 0) {
                   //     $.unblockUI();
                        modelAlert($('#<%=ddlOrganism.ClientID%> option:selected').text() + ' Already Added !!');
                        $("#<%=ddlOrganism.ClientID%>").prop('selectedIndex', 0);

                        return;
                    }
                }
            }
                $.ajax({
                    url: "MachineResultEntry_culture.aspx/BindobsAntibiotic",
                    data: '{ obid:"' + $('#<%=ddlOrganism.ClientID%>').val() + '",obname:"' + $('#<%=ddlOrganism.ClientID%> option:selected').text() + '",testid:"' + _test_id + '",Barcodeno:"' + _barcodeno + '",reportnumber:"' + $('#<%=ddlreportnumber.ClientID%>').val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        Obsrow = $.parseJSON(result.d);

                        if (Obsrow.length > 0) {
                            var mydata = '<tr class=' + Obsrow[0].obid + ' id="ObservationName" style="background-color:white;">';
                            mydata += '<td class="GridViewLabItemStyle"></td>';
                            mydata += '<td class="GridViewLabItemStyle" colspan="6" style="font-weight:bold;font-size:15px;" id="tdAntiName" >' + Obsrow[0].obname;
                            mydata += '&nbsp;&nbsp;&nbsp;<input type="button" onclick="removecurrentorganism(this)" value="Remove"  style="cursor:pointer;background-color:red;color:white;font-weight:bold;margin-left;" />';
                            var t1 = "txtcolonycount_" + Obsrow[0].obid;
                            var t2 = "txtcolonycountcomment_" + Obsrow[0].obid;
                            var t3 = "txtobsdisplayname_" + Obsrow[0].obid;
                            mydata += '<br/><strong style="font-size:12px;background-color:White;">Organism Display Name&nbsp;&nbsp;&nbsp;:</strong><input id=' + t3 + ' type="text" value="' + Obsrow[0].OrganismNameDisplayname + '" style="width:350px;font-size:12px;margin-left:140px;" class="OrganismNameDisplayname" autocomplete="off" /> ';
                           
                            mydata += '<br/><input type="text" id=' + t1 + ' class="colonycount" autocomplete="off" placeholder="Colony Count" style="width:100px;" value="' + Obsrow[0].colonycount + '" /> ';
                            mydata += '<input type="text" id=' + t2 + ' class="colonycountcomment" autocomplete="off" placeholder="Comment" style="width:552px;" value="' + Obsrow[0].colonycountcomment + '" />';
                            mydata += "</td></tr>";
                            $('#AntiBioTicList').append(mydata);
                            
                            for (var i = 0; i <= Obsrow.length - 1; i++) {


                                var mydata = '<tr class=' + Obsrow[i].obid + ' id=' + Obsrow[i].id;
                                if (Obsrow[i].id == "0") {

                                    mydata += ' style="background-color:white;" ';
                                }
                              
                                mydata += ' > ';
                                mydata += '<td class="GridViewLabItemStyle">';
                                if (Obsrow[i].id == "0") {
                                    mydata += ' <a href="javascript:void(0);" onclick="deletemeplz($(this));"><img src="../../images/Delete.gif"/></a> ';
                                }
                                else {
                                    mydata+= parseInt(i + 1);
                                }
                                mydata += '</td>';


                                mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tdAntiName" >' + Obsrow[i].name + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"><input onkeyup="_showhideList1(this,event,\'' + Obsrow[i].obid + '\',\'' + Obsrow[i].id + '\')"  class=' + Obsrow[i].obid + '_' + Obsrow[i].id + ' type="text" id="txtvalue" autocomplete="off" style="width:90px;" value="' + Obsrow[i].VALUE + '" />  <img id="imghelp" onclick="_showhideList(\'' + Obsrow[i].obid + '\',\'' + Obsrow[i].id + '\')" src="../../images/question_blue.png" /></td>';
                                mydata += '<td class="GridViewLabItemStyle"><input type="text" autocomplete="off" onkeyup="calculatebp(this)" id="txtmic" style="width:60px;" value="' + Obsrow[i].mic + '" /></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" autocomplete="off" style="width:60px;" id="txtbreakpoint" value="' + Obsrow[i].breakpoint + '" /></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" autocomplete="off" style="width:60px;" id="txtmicbreak" value="' + Obsrow[i].mic_bp + '" /></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none" id="tdAntiGroup">' + Obsrow[i].AntibioticGroupName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdAntiID" style="display:none;">' + Obsrow[i].id + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdAntiGroupID" style="display:none;">' + Obsrow[i].AntibioticGroupID + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdobname" style="display:none;">' + Obsrow[i].obname + '</td>';
                                mydata += "</tr>";
                                $('#AntiBioTicList').append(mydata);

                            }
                            jj = jj + 1;
                            var ss = "new" + jj;
                            var mydata = '<tr class=' + Obsrow[0].obid + ' id=' + ss + ' style="background-color:white">';
                            mydata += '<td class="GridViewLabItemStyle"></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tdAntiName" ><input type="text" autocomplete="off" style="width:80%;text-transform: uppercase;" id="txtnewanti"/><input type="button" value="AddNew" onclick="AddNewAntiRow(this,\'' + Obsrow[0].obid + '\',\'' + Obsrow[0].obname + '\')"/></td>';
                            mydata += '<td class="GridViewLabItemStyle"><input onkeyup="_showhideList1(this,event,\'' + Obsrow[0].obid + '\',\'' + ss + '\')"  class=' + Obsrow[0].obid + '_' + ss + ' type="text" id="txtvalue" autocomplete="off" style="width:90px;"  />  <img id="imghelp" onclick="_showhideList(\'' + Obsrow[0].obid + '\',\'' + ss + '\')" src="../../images/question_blue.png" /></td>';
                            mydata += '<td class="GridViewLabItemStyle"><input type="text"  autocomplete="off" onkeyup="calculatebp(this)" id="txtmic" style="width:60px;"  /></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text"  autocomplete="off" style="width:60px;" id="txtbreakpoint"  /></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text"  autocomplete="off" style="width:60px;" id="txtmicbreak"  /></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none" id="tdAntiGroup"></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdAntiID" style="display:none;">' + ss + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdAntiGroupID" style="display:none;"></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdobname" style="display:none;">' + Obsrow[0].obname + '</td>';
                            mydata += "</tr>";
                            $('#AntiBioTicList').append(mydata);
                        }
                        else {
                            modelAlert("No AntiBioTic Mapped with " + $("#<%=ddlOrganism.ClientID%> option:selected").text());
                        }

                        $("#<%=ddlOrganism.ClientID%>").prop('selectedIndex', 0);
                     //   $.unblockUI();
                    },
                    error: function (xhr, status) {
                     //   $.unblockUI();
                       window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        function deletemeplz(row) {
         
            row.closest('tr').remove();
           

        }
        var jj = 1;
        function AddNewAntiRow(ctrl,obid, obname) {
            jj = jj + 1;
            var ss = "new" + jj;
            var mydata = '<tr class=' + obid + ' id=' + ss + ' style="background-color:white">';
            mydata += '<td class="GridViewLabItemStyle"></td>';
            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tdAntiName" ><input type="text"  autocomplete="off" style="width:80%;text-transform: uppercase;" id="txtnewanti"/></td>';
            mydata += '<td class="GridViewLabItemStyle"><input onkeyup="_showhideList1(this,event,\'' + obid + '\',\'' + ss + '\')"  class=' + obid + '_' + ss + ' type="text"  autocomplete="off" id="txtvalue" autocomplete="off" style="width:90px;"  />  <img id="imghelp" onclick="_showhideList(\'' + obid + '\',\'' + ss + '\')" src="../../images/question_blue.png" /></td>';
            mydata += '<td class="GridViewLabItemStyle"><input type="text" autocomplete="off"  onkeyup="calculatebp(this)" id="txtmic" style="width:60px;"  /></td>';
            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" autocomplete="off"  style="width:60px;" id="txtbreakpoint"  /></td>';
            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text"  autocomplete="off" style="width:60px;" id="txtmicbreak"  /></td>';
            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none" id="tdAntiGroup"></td>';
            mydata += '<td class="GridViewLabItemStyle" id="tdAntiID" style="display:none;">' + ss + '</td>';
            mydata += '<td class="GridViewLabItemStyle" id="tdAntiGroupID" style="display:none;"></td>';
            mydata += '<td class="GridViewLabItemStyle" id="tdobname" style="display:none;">' + obname + '</td>';
            mydata += "</tr>";
            $(ctrl).parent("td").parent("tr").after(mydata);
        }

        function showantibiotic(micro) {

            if (micro != "" && micro != "null" && micro != "0") {

                debugger
                for (var i = 0; i < micro.split(',').length; i++) {
                    var chunk = micro.split(',')[i];

                    if (chunk != "") {
                        $('#divantibody').show();
                        $('#<%=ddlOrganism.ClientID%>').val(chunk);

                        AddAntibotic("0");
                    }

                }
            }
        }

        function antibioticdate() {
            var dataantibiotic = new Array();
            $('#AntiBioTicList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "antiheader" && id != "ObservationName") {
                    var plo = new Object();
                    plo.testid = _test_id;
                    plo.OrganismID = $(this).closest("tr").attr("class");
                    plo.OrganismName = $(this).closest("tr").find('#tdobname').html();
                    if (id.indexOf("new") >= 0) {
                        plo.Antibioticid = "0";
                        plo.AntibioticName = $(this).closest("tr").find('#txtnewanti').val();
                    }
                    else {
                        plo.Antibioticid = $(this).closest("tr").find('#tdAntiID').html();
                        plo.AntibioticName = $(this).closest("tr").find('#tdAntiName').html();
                    }
                    plo.AntibioticGroupid = $(this).closest("tr").find('#tdAntiGroupID').html();
                    plo.AntibioticGroupname = $(this).closest("tr").find('#tdAntiGroup').html();
                    plo.AntibioticInterpreatation = $(this).closest("tr").find('#txtvalue').val();
                    plo.MIC = $(this).closest("tr").find('#txtmic').val();
                    plo.BreakPoint = $(this).closest("tr").find('#txtbreakpoint').val();
                    plo.MIC_BP = $(this).closest("tr").find('#txtmicbreak').val();
                    plo.OrganismGroupID = $('#txtcolonycount_' + $(this).closest("tr").attr("class")).val();
                    plo.OrganismGroupName = $('#txtcolonycountcomment_' + $(this).closest("tr").attr("class")).val();
                    plo.Enzymename = $('#txtobsdisplayname_' + $(this).closest("tr").attr("class")).val();
                    dataantibiotic.push(plo);
                }
            });
            return dataantibiotic;
        }

        function removecurrentorganism(ctrl) {
            $('#AntiBioTicList').find('.' + $(ctrl).closest('tr').attr("class")).remove();
        }

        $('#AntiBioTicList').keydown(function (e) {
            if (e.keyCode == 13)
                e.preventDefault();

            var $table = $(this);
            var $active = $('input:focus,select:focus', $table);
            var $next = null;
            var focusableQuery = 'input:visible,select:visible,textarea:visible';
            var position = parseInt($active.closest('td').index()) + 1;
            //console.log('position :', position);
            switch (e.keyCode) {
                case 37: // <Left>
                    $next = $active.parent('td').prev().find(focusableQuery);
                    break;
                case 38: // <Up>                    
                    $next = $active
                        .closest('tr')
                        .prev()
                        .find('td:nth-child(' + position + ')')
                        .find(focusableQuery)
                    ;

                    break;
                case 39: // <Right>
                    $next = $active.closest('td').next().find(focusableQuery);
                    break;
                case 40: // <Down>
                    $next = $active
                        .closest('tr')
                        .next()
                        .find('td:nth-child(' + position + ')')
                        .find(focusableQuery)
                    ;
                    break;
            }
            if ($next && $next.length) {
                $next.focus();
            }
        });


        function calculatebp(obj) {
            var mic = $(obj).val();
            var bp = $(obj).closest("tr").find("#txtbreakpoint").val();
            if (mic == "" || isNaN(mic)) {
                //$(obj).closest("tr").find("#txtbpmic").val('');
                return;
            }

            if (bp == "" || isNaN(bp)) {
                $(obj).closest("tr").find("#txtmicbreak").val(mic);
                return;
            }

            var micbp = parseFloat(mic) / parseFloat(bp);

            $(obj).closest("tr").find("#txtmicbreak").val(parseFloat(micbp).toFixed(4));
        }
        function pickmeagain()
        {
            PatientSearch
            PickRowData(rowIndx);
        }

        //function AddReport(LedgerTransactionNo, _TestID)
        //{
        //    //var href = 'AddReport.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=' + _test_id;
        //    //fancypopup(href)

        //    $('#ctl00_ContentPlaceHolder1_popupctrl_hdnledgertransaction').val(LedgerTransactionNo);
        //    $('#ctl00_ContentPlaceHolder1_popupctrl_hdntestid').val(_TestID);
        //    serverCall('MachineResultEntry.aspx/BindTestDDL', { LedgerTransactionNo: LedgerTransactionNo, TestID: _TestID }, function (response) {
        //        var data = JSON.parse(response);
        //        var PatientDetails = data.PatientDetails;
        //        if (PatientDetails.length == 0) {
        //            modelAlert('This Test Is Not OutSource');
        //            return false;
        //        }
        //        $('#ctl00_ContentPlaceHolder1_popupctrl_ddlTestsaddreport option').remove()
        //        for (var i = 0; i < PatientDetails.length; i++) {
        //            $('#ctl00_ContentPlaceHolder1_popupctrl_ddlTestsaddreport').append($('<option></option>').html(PatientDetails[i]["Name"]).val(PatientDetails[i]["Test_ID"]));
        //        }
        //        bindAttachment(_TestID);
        //    });
        //    $('#AddReport').show();
        //}
        function AddRemarksOnpopup(LabNo, TestID, TestName)
        {
           // var href = 'AddRemarks_PatientTestPopup.aspx?LedgerTransactionNo=' + LabNo + '&TestID=' + TestID + '&TestName=' + TestName + '&Offline=0';
            // fancypopup(href)
            var Offline = "0";
            var Flag = "Other";
            AddRemarks(LabNo, TestID, TestName, Offline, Flag);
        }
        //function fancypopup(LedgerTransactionNo)
        //{
        //    serverCall('MachineResultEntry.aspx/BindPatientDetails', { LedgerTransactionNo: LedgerTransactionNo }, function (response) {
        //        var data = JSON.parse(response);
        //        var PatientDetails = data.PatientDetails;
        //        $('#lblUHID').text(PatientDetails[0]["PatientID"])
        //        $('#lblPatientName').text(PatientDetails[0]["PName"])
        //        $('#lblBarcodeNo').text(PatientDetails[0]["BarcodeNo"])
        //        var grvAttachment = data.grvAttachment;
        //        var grvAtt = "";
        //        $('#grvAttachment tr').slice(1).remove();
        //        for (var i = 0; i < grvAttachment.length; i++) {
        //            grvAtt += '<tr>';
        //            grvAtt += '<td><img alt="" src="../../Images/view.GIF" onclick="ViewDocument(\'' + grvAttachment[i].FileUrl + '\')" /></td>';
        //            grvAtt += '<td>' + grvAttachment[i].FileUrl + '</td>';
        //            grvAtt += '<td>' + grvAttachment[i].UploadedBy + '</td>';
        //            grvAtt += '<td>' + grvAttachment[i].Updatedate + '</td>';
        //            grvAtt += '</tr>';
        //        }
        //        $('#grvAttachment').append(grvAtt);
        //    });
        //    $('#ctl00_ContentPlaceHolder1_popupctrl_hdnledgertransaction').val(LedgerTransactionNo);
        //    $('#AddFile').show();
        //    //$.fancybox({
        //    //    maxWidth: 1250,
        //    //    maxHeight: 1250,
        //    //    fitToView: false,
        //    //    width: '94%',
        //    //    href: href,
        //    //    height: '90%',
        //    //    autoSize: false,
        //    //    closeClick: false,
        //    //    openEffect: 'none',
        //    //    closeEffect: 'none',
        //    //    'type': 'iframe'
        //    //});
        //}
    </script>
      <asp:Button ID="Button2" runat="server" style="display:none;" />
    <%-- <asp:Panel ID="Panel1" runat="server" BackColor="#EAF3FD" style="width:400px;border:2px solid maroon;display:none;" >
               <div class="Purchaseheader">Forward Test</div>
            <br />
          <table  style="width:99%;border-collapse:collapse;">
              <tr>
                  <td>&nbsp;Select Test:</td>
                  <td><asp:DropDownList ID="ddltest" runat="server" Width="200px"></asp:DropDownList></td>
              </tr>
              <tr>
                   <td>&nbsp;Select Centre:</td>
                     <td><asp:DropDownList ID="ddlcentre" runat="server" Width="200px" onchange="binddoctoforward()"></asp:DropDownList></td>
              </tr>
               <tr>
                   <td>&nbsp;Forward To:</td>
                     <td><asp:DropDownList ID="ddlforward" runat="server" Width="200px"></asp:DropDownList></td>
              </tr>
          </table>
                          <table style="width:100%" frame="box">
                              
                              <tr>
                                  <td align="right"><input type="button" value="Forward" onclick="Forwardme()" class="savebutton" /> </td><td><asp:Button ID="Button3" runat="server" Text="Close" CssClass="resetbutton" /></td>
                              </tr>
                              </table>
        </asp:Panel>


     <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server"  TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1" CancelControlID="Button3" BehaviorID="ModalPopupExtender2" >
    </cc1:ModalPopupExtender>--%>
    <div id="ModalPopupExtender2"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 400px;height: 200px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="ModalPopupExtender2" aria-hidden="true">&times;</button>
					<h4 class="modal-title"> Forward Test</h4>
				</div>
				<div class="modal-body">
					 				<div class="row" >
                                         <div class="col-md-10" >
                                             <b class="pull-left">Select Test  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddltest" runat="server" Width="200px"    ></asp:DropDownList>
                    </div> 
				</div>
			 	  		<div class="row" >
                                         <div class="col-md-10" >
                                             <b class="pull-left">Select Centre  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddlcentre" runat="server" Width="200px" onchange="binddoctoforward()"   > </asp:DropDownList>
                    </div> 
				</div>
                    	<div class="row" >
                                         <div class="col-md-10" >
                                             <b class="pull-left">Doctor Name </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddlforward" runat="server" Width="200px"    ></asp:DropDownList>
                    </div> 
				</div>
				</div>
				  <div class="modal-footer" style="text-align:center;"> 
                       <input type="button" value="Forward" onclick="Forwardme()" class="savebutton" /> 
				</div>
			</div>
		</div>
	</div>
    <div id="pnlnotapproved"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 400px;height: 150px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="pnlnotapproved" aria-hidden="true">&times;</button>
					<h4 class="modal-title"> Not Approved Remarks</h4>
				</div>
				<div class="modal-body">
					 				<div class="row" ">
                                         <div class="col-md-6" >
                                             <b class="pull-left">Remarks  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                       <asp:TextBox ID="txtnotappremarks" runat="server" MaxLength="200" Width="250px" placeholder="Enter Not Approved Remarks" style="text-transform:uppercase;" />
                    </div> 
				</div>
			 	  	<div class="row"> 
				</div>
				</div>
				  <div class="modal-footer" id="modalfooter" style="text-align:center;"> 
                       <input type="button" class="savebutton" onclick="NotApprovedFinaly()" value="Not Approved" />
				</div>
			</div>
		</div>
	</div>
 <%--    <asp:Panel id="pnlnotapproved" runat="server" style="display:none;width:300px;background-color:lightgray;">
        <div class="Purchaseheader">
           Not Approved Remarks
        </div>

        <center>
           <br /><br />
            &nbsp;&nbsp;
            <asp:Button ID="btnCancelNotapproved" runat="server" CssClass="resetbutton" Text="Cancel" /><br /><br />
        </center>
    </asp:Panel>


       <cc1:ModalPopupExtender ID="mpnotapprovedrecord" runat="server" CancelControlID="btnCancelNotapproved"
                            DropShadow="true" TargetControlID="Button2" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlnotapproved" BehaviorID="mpnotapprovedrecord">
                        </cc1:ModalPopupExtender> --%>


       <%-- <asp:Panel ID="pnlHoldRemarks" runat="server" Style="display: none;width:400px; " CssClass="pnlVendorItemsFilter" 
           >
        <div class="Purchaseheader" id="Div2" runat="server">
            <table style="width:100%; border-collapse:collapse" border="0">
                <tr>
                    <td>
                        <b>Hold Remarks</b>
                    </td>
                    <td style="text-align:right">
                        <em ><span style="font-size: 7.5pt"> Press esc or click
                            <img src="../../images/Delete.gif" style="cursor:pointer"  onclick="closeHoldRemarks()"/>                             
                                to close</span></em>
                    </td>
           </tr>
                </table>          
        </div>         
        <table style="border-collapse:collapse">
             <tr>
                    <td colspan="2" style="text-align:center">
                        <span id="spnHoldRemarks" class="AdministratorLblError"></span>
                        </td>
                </tr>
            <tr>
                <td style="text-align:right">
                    Remarks :&nbsp;
                </td>
                <td>
                    <input type="text" maxlength="50" id="txtHoldRemarks"  autocomplete="off"  style="width:240px" />
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center">
                    <input type="button" onclick="saveHoldRemarks()" value="Save" class="AdministratorButton"  />
                    <asp:Button ID="btnCancelHold" runat="server" CssClass="AdministratorButton" Text="Close"
                                        ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>--%>
     <asp:Button ID="btnHideHold" runat="server" Style="display:none" />
      <%--<cc1:ModalPopupExtender ID="mpHoldRemarks" runat="server" CancelControlID="btnCancelHold"
                            DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlHoldRemarks"  OnCancelScript="closeHoldRemarks()"  BehaviorID="mpHoldRemarks">
                        </cc1:ModalPopupExtender>--%>  
    <div id="pnlHoldRemarks"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 400px;height: 150px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="pnlHoldRemarks" aria-hidden="true">&times;</button>
					<h4 class="modal-title"> Hold Remarks</h4>
				</div>
				<div class="modal-body">
					 				<div class="row" ">
                                         <div class="col-md-6" >
                                             <b class="pull-left">Remarks  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                      <input type="text" maxlength="50" id="txtHoldRemarks" style="width:240px" />
                    </div> 
				</div>
			 	  	<div class="row"> 
				</div>
				</div>
				  <div class="modal-footer" style="text-align:center;"> 
                       <input type="button" onclick="saveHoldRemarks()" value="Save" class="ItDoseButton"  />
						 <button type="button"  data-dismiss="pnlHoldRemarks" aria-hidden="true" >Close</button>
				</div>
			</div>
		</div>
	</div>
  
</asp:Content>

