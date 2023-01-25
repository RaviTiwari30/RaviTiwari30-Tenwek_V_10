<%@ Page Title="Result Entry" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineResultEntry.aspx.cs" Inherits="PatientResultEntry" %>

    <%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %> 
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %> 
<%@ Register Src="~/Design/Lab/Popup.ascx" TagName="PopUp" TagPrefix="uc1" %>
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
    <style type="text/css">
        .uploadify {
            position: relative;
            margin-bottom: 1em;
            margin-left: 40%;
            margin-top: -40px;
            z-index: 999;
        }

        #MainInfoDiv {
            height: 490px !important;
        }

        .ReRun {
            background-color: #F781D8;
        }

        tr.FullRowColorInRerun td {
            background-color: #F781D8!important;
        }

        tr.FullRowColorInCancelByInterface td {
            background-color: #abb54c;
        }

        tr.FullRowColorInRed td {        
           background-color: #FF0000!important;
        
        }

        #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 300px;
            background: #FFFFFF;
            left: 400px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }

        #popup_box3 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 300px;
            background: #FFFFFF;
            left: 150px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }
    </style>
   
   
    <script type="text/javascript">


        var onOpenPacsViewer = function (el) {

            var pacsURL = 'Pac.aspx?LabNo=';
            var testID = _test_id;

            window.open(pacsURL + "" + testID, 'LaunchViewer', 'menubar=no1', 'toolbar=no1', 'dependent=yes');
        }

        var statusbuttonsearch = function (colsearch) {
            
            $('#ddlSampleStatus').chosen('destroy');
            //if (colsearch == "Pending") {
            //    $('#ddlSampleStatus').val(" and pli.Result_flag=0  and pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ");//.chosen();
            //}
            switch(colsearch){
                case 'Pending':
                    $('#ddlSampleStatus').val(" and pli.Result_flag=0  and pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ");//.chosen();
                    break;
                case 'Sample Collected':
                    $('#ddlSampleStatus').val(" and pli.isSampleCollected='S' and pli.Result_flag=0 ");//.chosen();
                    break;
                case 'Sample Receive':
                    $('#ddlSampleStatus').val(" and pli.isSampleCollected='Y' and pli.Result_flag=0 ");//.chosen();
                    break;
                case 'Machine Data':
                    $('#ddlSampleStatus').val(" and  pli.Result_Flag='0'  and pli.isSampleCollected<>'R'  and (select count(*) from mac_data md where md.Test_ID=pli.Test_ID  and md.reading<>'')>0 ");//.chosen();
                    break;
                case 'Tested':
                    $('#ddlSampleStatus').val(" and pli.Result_flag=1 and pli.approved=0 and pli.ishold='0'  and pli.isSampleCollected<>'R' ");//.chosen();
                    break;
                case 'Forwarded':
                    $('#ddlSampleStatus').val(" and pli.Result_flag=1 and pli.isForward=1 and pli.Approved=0  and pli.isSampleCollected<>'R' ");//.chosen();
                    break;
                case 'ReRun':
                    $('#ddlSampleStatus').val(" and pli.Result_flag=0 and pli.IsTestRerun=1 and  pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ");//.chosen();
                    break;
                case 'Approved':
                    $('#ddlSampleStatus').val(" and pli.Approved=1 and pli.isPrint=0 and pli.isSampleCollected<>'R' ");//.chosen();
                    break;
                case 'Hold':
                    $('#ddlSampleStatus').val(" and pli.isHold='1'  ");//.chosen();
                    break;
                case 'Printed':
                    $('#ddlSampleStatus').val(" and pli.isPrint=1  and pli.isSampleCollected<>'R' and pli.Approved=1 ");//.chosen();
                    break;
                case 'Rejected Sample':
                    $('#ddlSampleStatus').val(" and pli.isSampleCollected='R' ");//.chosen();
                    break;
            }
            //$('#ddlSampleStatus').val(colsearch);//.chosen();
            $('#ddlSampleStatus').chosen();
            SearchSampleCollection();
        }
    </script>


   
    
     <div class="alert fade" style="position:absolute;left:40%;border-radius:15px;top:20%;z-index:11111">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

   
    
     <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
    </Ajax:ScriptManager>

   
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Result Entry</b>                
                 </div>
         <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
            
                Search Option
             &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label  ID="lblTotalPatient"  ForeColor="white" runat="server" CssClass="ItDoseLblError" />
            </div> 
            <div class="col-md-1"></div>
        <div class="col-md-24">
            <div class="row">
            <div class="col-md-3">
                <label class="pull-left"> <asp:DropDownList ID="ddlSearchType"  runat="server">
                    <asp:ListItem Value="pli.BarcodeNo" Selected="True">Barcode No.</asp:ListItem>
                    <asp:ListItem Value="lt.PatientID">UHID No.</asp:ListItem>
                   <%--<asp:ListItem Value="pli.LedgerTransactionNo" >Visit No.</asp:ListItem>--%>
                 <asp:ListItem Value="pm.PName" >Patient Name</asp:ListItem>
             </asp:DropDownList></label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">  <asp:TextBox ID="txtSearchValue"  runat="server" ></asp:TextBox></div>
                <div class="col-md-3">
<label class="pull-left">Depatment</label>
                    <b class="pull-right">:</b>
        </div>
               <div class="col-md-5" >
                      <asp:DropDownList ID="ddlDepartment" class="ddlDepartment  chosen-select" runat="server">
                        </asp:DropDownList>
            </div>
                <div class="col-md-3">
                         <asp:TextBox ID="txtCommentValueSet"  runat="server" Width="150px" style="display:none;"></asp:TextBox>
                 <asp:CheckBox ID="chkPanel" runat="server" onClick="BindPanel();" Text="Rate Type :" style="font-weight: 700;display:none" />
                    <label class="pull-left">Status</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:DropDownList ID="ddlSampleStatus" runat="server" class="ddlSampleStatus  chosen-select" ClientIDMode="Static">
                                 <asp:ListItem  Value="  and pli.isSampleCollected<>'N' ">All Patient</asp:ListItem>
                                 <asp:ListItem  Value=" and pli.Result_flag=0  and pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' " >Pending</asp:ListItem>
                                 <asp:ListItem  Value=" and pli.isSampleCollected='S' and pli.Result_flag=0 ">Sample Collected</asp:ListItem>
                                 <asp:ListItem  Value=" and pli.isSampleCollected='Y' and pli.Result_flag=0 ">Sample Receive</asp:ListItem>
                                 <asp:ListItem  Value=" and  pli.Result_Flag='0'  and pli.isSampleCollected<>'R'  and (select count(*) from mac_data md where md.Test_ID=pli.Test_ID  and md.reading<>'')>0 ">Machine Data</asp:ListItem>                                
                                 <asp:ListItem  Value=" and pli.Result_flag=1 and pli.approved=0 and pli.ishold='0'  and pli.isSampleCollected<>'R' ">Tested</asp:ListItem>
                                 <asp:ListItem  Value=" and pli.Result_flag=1 and pli.isForward=1 and pli.Approved=0  and pli.isSampleCollected<>'R' ">Forwarded</asp:ListItem>
                                 <asp:ListItem  Value=" and pli.Result_flag=0 and pli.IsTestRerun=1 and  pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ">ReRun</asp:ListItem>
                                 <asp:ListItem  Value=" and pli.Approved=1 and pli.isPrint=0 and pli.isSampleCollected<>'R' ">Approved</asp:ListItem>
                                 <asp:ListItem  Value=" and pli.isHold='1' and pli.approved=0 ">Hold</asp:ListItem>
                                 <asp:ListItem  Value=" and pli.isPrint=1  and pli.isSampleCollected<>'R' and pli.Approved=1 ">Printed</asp:ListItem>                             
                                 <asp:ListItem  Value=" and pli.isSampleCollected='R'  ">Rejected Sample</asp:ListItem>
                        </asp:DropDownList>
                </div>

            </div> 
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                         <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="150px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                         
                               <asp:TextBox ID="txtFromTime" runat="server" Width="90px"></asp:TextBox>
                                 <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                                                             AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                                                            
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                                        ControlExtender="mee_txtFromTime"
                                        ControlToValidate="txtFromTime"
                                        InvalidValueMessage="*"  >
                                 </cc1:MaskedEditValidator>
                </div>

                <div class="col-md-3">
                     <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate"  CssClass="ItDoseTextinputText"  runat="server" ReadOnly="true"  Width="150px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                            
                            
                              <asp:TextBox ID="txtToTime" runat="server" Width="90px"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">                        
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                        ControlExtender="mee_txtToTime"  ControlToValidate="txtToTime"  
                                        InvalidValueMessage="*"  >
                                </cc1:MaskedEditValidator> 
                </div>

                <div class="col-md-3">
                    <label class="pull-left"><asp:CheckBox ID="chkPanel0" runat="server" onchange="BindTest();" Text="Test" ClientIDMode="Static" style="font-weight: 700;" />
                        </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:DropDownList ID="ddlinvestigation" class="ddlinvestigation  chosen-select" runat="server">
                        </asp:DropDownList>
                </div>

            </div>
            <div class="row">
               
                 <div class="col-md-3">
                    <label class="pull-left">TAT Option</label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddltatoption" runat="server">
                                  <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                  <asp:ListItem Value="1" style="background-color: green !important;color:white;" >WithIn TAT</asp:ListItem>
                                  <asp:ListItem Value="2" style="background-color: yellow !important;">Near TAT</asp:ListItem>
                                  <asp:ListItem Value="3" style="background-color: red !important;color:white">Outside TAT</asp:ListItem>
                              </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Machine</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                       <asp:DropDownList ID="ddlMachine" class="ddlMachine chosen-select" runat="server">
                        </asp:DropDownList>
                </div>
                 <div class="col-md-3">
                     <asp:Label ID="lblDoctor" runat="server" CssClass="" Text="Doctor"   Visible="False" />
                     
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   
                    <asp:DropDownList ID="ddlEmployee" runat="server"  Visible="False"></asp:DropDownList>
                </div>
            </div>
              <div class="row">
               
                 <div class="col-md-3">
                    <label class="pull-left">Patient Type</label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPatientType" runat="server">
                                  <asp:ListItem Value="0">ALL</asp:ListItem>
                                  <asp:ListItem Value="1">OPD</asp:ListItem>
                                  <asp:ListItem Value="2">IPD</asp:ListItem>
                              </asp:DropDownList>
                </div>
                <div class="col-md-3">
       <label class="pull-left">Test Type</label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <input id="ChkIsUrgent" type="checkbox" />  <strong>Urgent Test </strong>
                </div>
                 <div class="col-md-3">
                   
                </div>
                <div class="col-md-5">
                    
                </div>
            </div>
            <div class="row" style="text-align:center;">
               <div  style="text-align:center">
                    <input id="btnSearch" type="button" value="Search"  class="searchbutton" onclick="SearchSampleCollection();"/>
                      <input type="button" id="back" class="resetbutton" value="Back" onclick="closeme()" style="display:none;" />  
                </div>
            </div>
            <div class="row" style="text-align:center;    margin-left: 203px;">
                <div>
                     <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Collected" onclick="statusbuttonsearch('Sample Collected')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Collected</b>
                            <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Received" onclick="statusbuttonsearch('Pending')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Pending</b>
                             <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle MacData" onclick="statusbuttonsearch('Machine Data')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">MacData</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Tested" onclick="statusbuttonsearch('Tested')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Tested</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle ReRun" onclick="statusbuttonsearch('ReRun')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">ReRun</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Forwarded" onclick="statusbuttonsearch('Forwarded')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Forwarded</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Approved" onclick="statusbuttonsearch('Approved')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Approved</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Printed" onclick="statusbuttonsearch('Printed')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Printed</b>
                     <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Hold" onclick="statusbuttonsearch('Hold')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Hold</b>
                      <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Rejected" onclick="statusbuttonsearch('Rejected Sample')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Rejected</b>
            </div>        
            </div>
        </div> <div class="col-md-1">   
            <asp:CheckBox ID="chremarks" Font-Bold="true" runat="server" Text="Remarks Status" style="display:none;" />
<asp:CheckBox ID="chcomments" Font-Bold="true" runat="server" Text="Comments Status" style="display:none;"/>
            <asp:DropDownList ID="ddlZSM"  Width="155px" runat="server" style="display:none;">  </asp:DropDownList>
                      </div>
                        </div>
                        
        <div class="POuter_Box_Inventory">
    <div id="divPatient" class="vertical" style="max-height:380px;"></div>
            <div id="MainInfoDiv" class="vertical" style="position: relative; ">
                <div class="Purchaseheader">
                    <div class="DivInvName" style="color: Black; cursor: pointer; font-weight: bold;"></div>
                </div>
                 <div id="SelectedPatientinfo" style="margin-top:2%;">
                </div>  
    <div id="divInvestigation">
    </div>
              
                <div id="divRadiologyEditor" style="display: none; position: absolute; top: 2px; left: 10px;">
                        <div style="text-align:left">
                    <p><span id="spInvestigationName" style="font-size:14px"></span></p></div>
                    <div  style="width:1200px;margin-left:6px">
                        <div class="row">
                            <div class="col-md-3">
                                 <p id="commentbox1"><span id="commentHead1">
                                <label class="pull-left" style="margin-top:-11px">Templates</label>
                                <b class="pull-right"  style="margin-top:-11px">:</b></span>
                           </p>
                            </div>
                            <div class="col-md-5">
 <select id="ddlCommentsLabObservation1"  onchange="ddlCommentsLabObservation1_Load(this.value);" 
                                style="margin-left: 5px;height: 25px;margin-top:0px;width:200px"></select>
                            </div>
                            <div class="col-md-3" style="display:none">
                                 <input type="file" name="file_upload_Radio" id="file_upload_Radio" style="margin-top:5px;" /> 
                            </div>
                            <div class="col-md-4" style="text-align:right">
                                <%----%>
                                <input type="button" value="Clear Text"  style="margin-top: 3px;margin-left:706px" onclick='ClearRadiologyComment();' /></div>
                           
                          
                           <div class="col-md-4" style="text-align:right">
                                    <input type="button" value="PACS Images" style="margin-top: 3px;margin-left:403px"   onclick='onOpenPacsViewer(this);' /></div>
                           
                        </div>
                        <div class="row" style="height:100px;">
                    <CKEditor:CKEditorControl ID="CKEditorControl2" BasePath="~/ckeditor" runat="server" Height="180" ></CKEditor:CKEditorControl>
                            </div>
                    <%--<input type="button" value="Clear Text" style="margin-top: -15px;" onclick='ClearRadiologyComment();' />--%>
                </div>
                   
                </div> 
                                   
            <div style="display:none;">
                  <br />
                <input id="btnUpdateBarcodeInfo" class="ItDoseButton" type="button" value="Save" style="display:none" onclick="UpdateBarcodes();"  disabled/>
            </div>    
             <div class="divFinding" style="display:none">
                  <div class="row">
                            <div class="col-md-3">
                                <label class="pulll-left">Finding</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21">
                               <input type="text" id="txtFinding" placeholder="Enter Finding here . Max 200 character" maxlength="200" />
                            </div>
                        </div>
             </div>                
            <div style="padding-top:2px;" class="btnDiv">
                    <span style="color:black;font-weight:bold;">Machine:</span>
                    <asp:DropDownList ID="ddlTestDon" runat="server"  onchange="PicSelectedRow()" Width="95px" ></asp:DropDownList>               
                    <input id="btnPreLabObs" type="button" value="<<" class="demo ItDoseButton" onclick="PreLabObs();" style="width:50px;height:25px" disabled/>
                    <input id="btnNextLabObs" type="button" value=">>" class="demo ItDoseButton" onclick="NextLabObs();" style="width:50px;height:25px" disabled/>                
                   <input id="btnSaveLabObs" type="button" value="Save" class="ItDoseButton btnForSearch demo SampleStatus" onclick="Save();" style="width:auto;height:25px;" disabled/>               
                <%                  
                    if (ApprovalId == "")
                    { %>                           
            <%}
                    else
                    {
                        if (ApprovalId == "1" || ApprovalId == "3" || ApprovalId == "4")
                        {%>
                <asp:DropDownList ID="ddlApprove" runat="server" Width="150px"  ></asp:DropDownList>
                    <input id="btnApprovedLabObs" type="button" value="Approved" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Approved();" style="width:auto;height:25px;" disabled/>
                <input id="btnPreliminary" type="button" value="Preliminary Report" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Preliminary();" style="width:auto;height:25px;display:none;" disabled/>
                 <input id="btnholdLabObs" type="button" value="Hold" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Hold();" style="width:auto;height:25px;display:none;" disabled/>
                <% if (ApprovalId == "4" || ApprovalId == "3")
                   {%>
                    <input id="btnNotApproveLabObs" type="button" value="Not Approved" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="NotApproved();" style="width:auto;height:25px;" disabled/>
                    
                <%if (ApprovalId == "4")
                  { 
                  %>
                   <input id="btnUnholdLabObs" type="button" value="Un Hold " class="ItDoseButton btnForSearch  SampleStatus demo" onclick="UnHold();" style="width:auto;height:25px;"disabled/>
                 <% }
                   }
                        }

                        if (ApprovalId == "2" || ApprovalId == "3" || ApprovalId == "4")
                        {%>
                    <input id="btnForwardLabObs" type="button" value="Forward" class="ItDoseButton btnForSearch  SampleStatus demo"  onclick="Forward();" style="height:25px;" disabled />
                <%}
                   
%>
<input id="btnUnForwardLabObs" type="button" value="Un Forward" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="UnForward();"  />
<%

                    }%>
                <input id="btnAddFileLabObs" type="button" value="Add File" class="ItDoseButton" onclick="fancypopup(LedgerTransactionNo);"  style="width:auto;height:25px;"/> <%--'AddAttachment.aspx?LedgerTransactionNo=' +--%>

                 <input id="btnaddreport" type="button" value="Add Report" class="ItDoseButton" onclick="AddReport(LedgerTransactionNo, _test_id)"  style="width:auto;height:25px;"/>
                

                  <input id="Button5" type="button" value="Sample Reject" class="ItDoseButton" onclick="showRejectSample(_test_id)"  style="width:auto;height:25px;display:none"/>

                <input id="btnPrintReportLabObs" type="button" value="Print PDF" class="ItDoseButton btnForSearch demo " onclick="PrintReport('0');" disabled style="width:auto;height:25px;"/>
                 <input id="btnPreview" type="button" value="Preview PDF" class="ItDoseButton btnForSearch demo " onclick="PrintReport('1');" disabled style="width:auto;height:25px;"/>
                <input id="btnPatientDetail" type="button" value="Patient Detail"  class="ItDoseButton" style="width:auto;height:25px;"/>
                <input id="btnPatientHistory" type="button" value="Patient History"  class="ItDoseButton" style="width:auto;height:25px;"/>
                 <input id="Button1" type="button" value="Delta Check"  class="ItDoseButton" style="width:auto;height:25px;" onclick="opendeltapoup()" />
                <a id="various2" style="display:none">Ajax</a>  
                
				<input id="btnSide" type="button" value="Main List"  class="ItDoseButton" onclick="MainList();"  style="width:auto;height:25px;"/>

                
				<input id="btnRecollect" type="button" value="Recollect"  class="ItDoseButton" onclick="openRecollectModel(LedgerTransactionNo)"  style="width:auto;height:25px;"/>


                
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
     <div id="deltadiv" style="display:none;position:absolute;">          
        </div>
     <script type="text/javascript">
         //function AddReport(LedgerTransactionNo, _TestID) {
         //    //var href = 'addreport.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=' + _test_id;
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
         function AddRemarksOnpopup(LabNo, TestID, TestName) {
             // var href = 'AddRemarks_PatientTestPopup.aspx?LedgerTransactionNo=' + LabNo + '&TestID=' + TestID + '&TestName=' + TestName + '&Offline=0';
             var Offline = "0";
             var Flag = "Other";
             AddRemarks(LabNo, TestID, TestName, Offline, Flag);
            // fancypopup(href)
         }
         //function bindAttachment(TestID) {
         //    if (TestID = 'DdlCall') {
         //        TestID =  $('#ctl00_ContentPlaceHolder1_popupctrl_ddlTestsaddreport option:selected').val();
         //    }
             
         //    serverCall('MachineResultEntry.aspx/bindAttachment', { TestID: TestID }, function (response) {
         //        var data = JSON.parse(response);
         //        var dtdetail = data.dtdetail;
         //        var grvAtt = "";
         //        $('#grdaddreport tr').slice(1).remove();
         //        for (var i = 0; i < dtdetail.length; i++) {

         //            grvAtt += '<tr>';
         //            if (dtdetail[i].Approved == "1") {
         //                grvAtt += '<td></td>';
         //            }
         //            else {
         //                grvAtt += '<td><img alt="" src="../../Images/Delete.GIF" onclick="RemoveData(\'' + dtdetail[i].Test_ID + '\',\'' + dtdetail[i].FileUrl + '\')" /></td>';
         //            }
         //            grvAtt += '<td><img alt="" src="../../Images/view.GIF" onclick="ViewDocumentReport(\'' + dtdetail[i].FileUrl + '\')" /></td>';
         //            grvAtt += '<td>' + dtdetail[i].FileUrl + '</td>';
         //            grvAtt += '<td>' + dtdetail[i].UploadedBy + '</td>';
         //            grvAtt += '<td>' + dtdetail[i].dtEntry + '</td>';
         //            grvAtt += '</tr>';
         //        }
         //        $('#grdaddreport').append(grvAtt);
         //    });
         //}

         function RemoveData(Test_ID, FileUrl) {
             serverCall('MachineResultEntry.aspx/RemoveData', { TestID: Test_ID, FileUrl: FileUrl }, function (response) {
                 if (response== true) {
                     modelAlert('File Deleted Successfully', function () {
                         bindAttachment(Test_ID);
                     });
                 }
             });

         }
         //function fancypopup(LedgerTransactionNo) {
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
         //    //serverCall('/MachineResultEntry.aspx/BindPatientDetails', { LedgerTransactionNo: LedgerTransactionNo }, function (response) {
         //    // var   data = JSON.parse(response);
         //    // var PatientDetails = data.PatientDetails;
         //    // var grvAttachment = data.grvAttachment;
         //    // }); 

         //    //$.fancybox({
         //    //    maxWidth: 1155,
         //    //    maxHeight: 1000,
         //    //    fitToView: false,
         //    //    width: '95%',
         //    //    href: href,
         //    //    height: '85%',
         //    //    autoSize: false,
         //    //    closeClick: false,
         //    //    openEffect: 'none',
         //    //    closeEffect: 'none',
         //    //    'type': 'iframe'
         //    //});
         //}
         $(document).ready(function () {
             var config = {
                 '.chosen-select': {},
                 '.chosen-select-deselect': { allow_single_deselect: true },
                 '.chosen-select-no-single': { disable_search_threshold: 10 },
                 '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                 '.chosen-select-width': { width: "95%" }
             }
             for (var selector in config) {
                 $(selector).chosen(config[selector]);
             }
             $('#<%=txtSearchValue.ClientID%>').keypress(function (ev) {
                 if (ev.which === 13)
                     SearchSampleCollection();
             });
         });
            </script>
    <script type="text/javascript">

        function opendeltapoup() {
            $('#Panel2').show();
        }
        function opendelta1() {
            $('#Panel2').hide();
            window.open('DeltacheckNew.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=' + _test_id, '');
        }
        function opendelta2() {
            $('#Panel2').hide();
            window.open('DeltacheckGraph.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=' + _test_id, '');
        }
        function BindCentre() {
            // // $.blockUI();





            var ddlDoctor = "";
            var chkDoc = "";
            $.ajax({

                url: "MachineResultEntry.aspx/bindAccessCentre",
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
                        ddlDoctor.append($("<option></option>").val("ALL").html("ALL"));
                        for (i = 0; i < PanelData.length; i++) {

                            ddlDoctor.append($("<option></option>").val(PanelData[i]["CentreID"]).html(PanelData[i]["Centre"]));
                        }
                    }
                    ddlDoctor.trigger('chosen:updated');

                    // $.unblockUI();
                },
                error: function (xhr, status) {
                    //alert("Error ");

                    ddlDoctor.trigger('chosen:updated');

                    // $.unblockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }


        function BindTest() {
            var ddlDoctor = $("#<%=ddlinvestigation.ClientID %>");
            ddlDoctor.find('option').remove();
            var checkBox = document.getElementById("chkPanel0");
            if (checkBox.checked == true) {
                // // $.blockUI();
                $.ajax({

                    url: "MachineResultEntry.aspx/GetTestMaster",
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
                            ddlDoctor.append($("<option></option>").val(0).html("SELECT"));
                            for (i = 0; i < PanelData.length; i++) {
                                ddlDoctor.append($("<option></option>").val(PanelData[i]["testid"]).html(PanelData[i]["testname"]));
                            }
                        }
                        ddlDoctor.trigger('chosen:updated');
                        // // $.unblockUI();
                    },
                    error: function (xhr, status) {
                        ddlDoctor.trigger('chosen:updated');
                        // $.unblockUI();
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                ddlDoctor.val(0);
                ddlDoctor.trigger('chosen:updated');
            }
        }


    </script>

    <script type="text/javascript" >
        var PatientData = '';
        var LabObservationData = '';
        var _test_id = '';
        var _barcodeno = '';
        var hot2;
        var modal = "";
        var span = "";
        var currentRow = 1;
        var resultStatus = "";
        var criticalsave = "0";
        var macvalue = "0";
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
        //$(".DivInvName").mouseleave(function () {
        //    $('#deltadiv').hide();
        //});
        function getme(testid) {
            //$modelBlockUI();
            var turl = "../../Design/Lab/showreading.aspx?TestID=" + testid;
            //alert(turl);
            $.ajax({
                url: turl,
                dataType: 'html',
                success: function (html) {
                    //... rest of your code that should be added into the load function.
                    //alert(html);
                    $('#deltadiv').html(html).css({ 'top': mouseY, 'left': mouseX }).show();
                }
            });
            //$('#deltadiv').load(url);
            // $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
        }
        $(document).ready(function () {
            $('body').click(function () {
                $('#deltadiv').hide();
            });
        });

        function hideme() {
            $('#deltadiv').hide();
        }
        function showdelta(testid, labobserid) {
            var url = "../../Design/Lab/DeltaCheck.aspx?TestID=" + testid + "&LabObservation_ID=" + labobserid;
            $.ajax({
                url: url,
                dataType: 'html',
                success: function (html) {
                    //... rest of your code that should be added into the load function.
                    //alert(html);
                    $('#deltadiv').html(html).css({ 'top': mouseY, 'left': mouseX }).show();
                }
            });
            //$('#deltadiv').load(url);
            //$('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
        }
        function hidedelta() {
            $('#deltadiv').hide();
        }
        function showCompanyName() {
            var CName = $('#cNameid').text();
            //alert(CName);
            var url = "../../Design/Lab/CheckCompanyName.aspx?CName=" + CName;
            $('#deltadiv').load(url);
            $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
        }
        function hideCompaneName() {
            $('#deltadiv').hide();
        }
        $(document).ready(function () {
            // ManageDivHeight();
            $('#MainInfoDiv').hide();
            $('.btnDiv').hide();
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            $('#divPatient').removeClass('vertical');
            $('#divPatient').addClass('horizontal');
            //$('#divPatient').css('height', '330px');
            $('#MainInfoDiv').hide();
            $('.btnDiv').hide();
            $('#btnSide').hide();
            $('#btnUpdateBarcodeInfo').show();
                <%}%>
            elt = document.getElementById('<%=ddlSampleStatus.ClientID%>');
            MYSampleStatus = elt.options[elt.selectedIndex].text;
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
            //span.onclick = function () {
            //    modal.style.display = "none";
            //}
            // When the user clicks anywhere outside of the modal, close it
                window.onclick = function (event) {
                    if (event.target == modal) {
                        //   modal.style.display = "none";
                    }
                }
        });
            function ManageDivHeight() {
                $('#divInvestigation').removeClass('vertical');
                $('#divPatient').removeClass('vertical');
                $('#divInvestigation').addClass('horizontal');
                $('#divPatient').addClass('horizontal');
            }
            function UpdateSampleStatus() {
                try {
                    MYSampleStatus = elt.options[elt.selectedIndex].text;
                }
                catch (e) {
                    MYSampleStatus = "Tested";
                }
                $('.SampleStatus').hide();
                if (MYSampleStatus == "Forwarded") {
                    $('#btnApprovedLabObs').show();
                    $('#btnUnForwardLabObs').show();

                }
                // $('.btnDiv').show();
                if (MYSampleStatus == "Tested" || MYSampleStatus == "Preliminary report") { $('#btnForwardLabObs').show(); $('#btnApprovedLabObs').show(); }
                if (MYSampleStatus == "Approved" || MYSampleStatus == "Printed") { $('#btnNotApproveLabObs').show(); }
                if (MYSampleStatus == "Pending" || MYSampleStatus == "ReRun" || MYSampleStatus == "Tested" || MYSampleStatus == "Machine Data" || MYSampleStatus == "Preliminary report" || MYSampleStatus == "Sample Receive") { $('#btnSaveLabObs').show(); $('#btnApprovedLabObs').show(); }
                if (MYSampleStatus == "Tested" && MYSampleStatus != "Approved" || MYSampleStatus == "Preliminary report") { }
                if (MYSampleStatus == "Pending" || MYSampleStatus == "ReRun" || MYSampleStatus == "Tested") { $('#btnholdLabObs').show(); }
                if (MYSampleStatus == "Hold") { $('#btnUnholdLabObs').show(); $('#btnApprovedLabObs').hide(); }
                if (MYSampleStatus == "Pending") { $('#Button5').show(); }
            }

            var
                            data,
                            container1,
                            hot1;

            function SearchSampleCollection() {
                var investigationID = "";
                var PanelId = "";
                investigationID = $('#<%=ddlinvestigation.ClientID%>').val();
                //alert(investigationID);

                $('#divPatient').show();
                $('#MainInfoDiv').hide();
                $('.btnDiv').hide();
                $('#SelectedPatientinfo').hide();
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
                // // $.blockUI();
                var forwardtodoctor = null;
                if ($('#<%=ddlEmployee.ClientID %>').val() != "0")
                {
                    forwardtodoctor = $('#<%=ddlEmployee.ClientID %>').val();
                }
                $.ajax({
                    url: "MachineResultEntry.aspx/PatientSearch",
                    data: '{ SearchType: "' + $("#<%=ddlSearchType.ClientID %>").val() + '",SearchValue:"' + $("#<%=txtSearchValue.ClientID %>").val() + '",FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",SmpleColl:"' + $("#<%=ddlSampleStatus.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '",MachineID:"' + $('#<%=ddlMachine.ClientID%>').val() + '",ZSM:"' + $("#<%=ddlZSM.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",TimeTo:"' + $("#<%=txtToTime.ClientID%>").val() + '",isUrgent:"' + isUrgent + '",InvestigationId:"' + investigationID + '",PanelId:"' + PanelId + '", SampleStatusText:"' + $('#<%=ddlSampleStatus.ClientID %> option:selected').text() + '",chremarks:"' + chremarks + '",chcomments:"' + chcomments + '",TATOption:"' + $("#<%=ddltatoption.ClientID %>").val() + '",PatientType:' + $("#<%=ddlPatientType.ClientID %>").val() + ',ForwardToDoctor:"' + $('#<%=ddlEmployee.ClientID %>').val() + '"}', // parameter map 
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
                            // $.unblockUI();
                            modelAlert('Your Session Expired.... Please Login Again');
                            return;
                        }
                        if (PatientData.length == 0) {
                            $('#<%=lblTotalPatient.ClientID%>').text('');
                            $('#btnUpdateBarcodeInfo').attr('disabled', true);
                            $("#btnSearch").removeAttr('disabled').val('Search');
                            // $.unblockUI();
                            //  $("#<%=lblMsg.ClientID %>").text('No Record Found');
                            modelAlert('No Record Found');
                            return;
                        }
                        else {
                            UpdateSampleStatus();
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
                                   "S.No.", "TAT", "Bill Date", "Type", "Barcode No.", "IPDNo.", "UHID No.", "Patient Name", "Age/Sex", "Tests", "Panel", "Status", "Clinic", "Doctor", "Panel", "Booking Center", "TimeDiff", "Dept Rec. Date", 'SC Withdraw Req Date', 'SC Actual Withdraw Date', 'Devation Time', "Detail", "View Doc.", "Print"
                                ],
                                readOnly: true,
                                currentRowClassName: 'currentRow',
                                columns: [
                                    { renderer: AutoNumberRenderer, width: '60px' },
                                    { renderer: TATStatus, width: '60px' },
                                { data: 'BillDate' },
                                 { data: 'PatientType' },
                                { data: 'BarcodeNo', renderer: safeHtmlRenderer, align: 'center' },
                               // { data: 'BarcodeNo', renderer: EnableBarcode, width: '100px' },
                               { data: 'IPDNo' },
                                { data: 'PatientID' },
                                { data: 'PName', width: '200px' },
                                { data: 'Age_Gender', width: '100px' }, // , renderer: safeHtmlRenderer 
                                { data: 'Test', width: '200px', renderer: safeTestRenderer },
                                { data: 'panelname', width: '150px', },
                                { data: 'Status' },
                                { data: 'Clinic' },
                                  { data: 'Doctor', width: '150px', },
                                
                                    { data: 'Centre' },
                                    { data: 'TimeDiff' },
                                { data: 'DATE' },
                                    { data: 'Samplerequestdate' },
                                    { data: 'Acutalwithdrawdate' },
                                    { data: 'DevationTime' },
                                { renderer: PatientDetail },
								{ renderer: ShowAttachment },
                              //   { data: 'Test_ID', renderer: SampleIconRenderer },
                                { renderer: PrintreportRenderer },
                               // { renderer: SampleStatusRenderer }//   , renderer: safeHtmlRenderer 
                              //  { data: 'Test_ID', renderer: RemarksFieldRenderer },
                                //{ data: 'RemarkStatus', readOnly: false, width: '150px' },//, renderer: RemarksFieldRenderer
                                //{ data: 'Comments', width: '150px' }

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
                                    updateRemarks(change);
                                }
                            });
                            hot1.render();
                            hot1.selectCell(0, 0);
                            //if (PatientData.length > 0)
                            //    SearchInvestigation(PatientData[0].ledgerTransactionNO);
                            $("#btnSearch").removeAttr('disabled').val('Search');
                            // $.unblockUI();
                            CallFancyBox();
                            //return;
                        }
                    },
                    error: function (xhr, status) {
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        // $.unblockUI();
                        $('#divPatient').html('');
                        modelAlert('Error Occured..');
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
                url: "MachineResultEntry.aspx/SaveRemarksStatus",
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
        function showmsgCombinationSample(location) {
            modelAlert("Sample Combination::  " + location);
            //$('#msgField').html('');
            //$('#msgField').append();
            //$(".alert").css('background-color', 'red');
            //$(".alert").removeClass("in").show();
            //$(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function callPatientDetail(PTest_ID, PLeddNo) {
            //var href = "../Lab/PatientSampleinfoPopup.aspx?TestID=" + PTest_ID + "&LabNo=" + PLeddNo;
            //$.fancybox({
            //    maxWidth: 860,
            //    maxHeight: 800,
            //    fitToView: false,
            //    width: '80%',
            //    height: '70%',
            //    href: href,
            //    autoSize: false,
            //    closeClick: false,
            //    openEffect: 'none',
            //    closeEffect: 'none',
            //    'type': 'iframe'
            //}
            //);
            CommonPatientinfo(PLeddNo, PTest_ID, 'Other')
        }
        function callShowAttachment(PLeddNo) {
            //var href = "../Lab/AddAttachment.aspx?LedgerTransactionNo=" + PLeddNo;
            //$.fancybox({
            //    maxWidth: 1200,
            //    maxHeight: 800,
            //    fitToView: false,
            //    width: '80%',
            //    height: '70%',
            //    href: href,
            //    autoSize: false,
            //    closeClick: false,
            //    openEffect: 'none',
            //    closeEffect: 'none',
            //    'type': 'iframe'
            //}
            //);
            fancypopup(PLeddNo);
        }
        function PatientDetail(instance, td, row, col, prop, value, cellProperties) {
            //td.innerHTML = '<a target="_blank" id="aa" href="../Lab/PatientSampleinfoPopup.aspx?TestID=' + PatientData[row].Test_ID + '&LabNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../Images/view.GIF" style="border-style: none" alt="">     </a>';          
            td.innerHTML = '<img  src="../../Images/view.GIF" style="border-style: none;cursor:pointer;" alt="" onclick="callPatientDetail(' + "'" + '' + PatientData[row].Test_ID + "'" + ',' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');">     </a>';
            td.className = PatientData[row].Status;
            return td;
        }
        function ShowAttachment(instance, td, row, col, prop, value, cellProperties) {
            var MyStr1 = "";
            if (PatientData[row].DocumentStatus != "") {
                //  MyStr1 = MyStr1 + '<a target="_blank" id="mm"  href="../Lab/ShowAttachment.aspx?labno=' + PatientData[row].LedgerTransactionNo + '"  > <img  src="../../Images/attachment.png" style="border-style: none;width:20px;" alt=""></a>';
                // MyStr1 = MyStr1 + '<a target="_blank" id="mm"  href="../Lab/AddFileRegistration.aspx?labno=' + PatientData[row].LedgerTransactionNo + '"  > <img  src="../../Images/attachment.png" style="border-style: none;width:20px;" alt=""></a>';
                MyStr1 = MyStr1 + '<img  src="../../Images/attachment.png" style="border-style: none;width:20px;cursor:pointer;" alt="" onclick="AddReport(' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ',' + "'" + '' + PatientData[row].Test_ID + "'" + ');"></a>';
            }
            td.innerHTML = MyStr1;
            td.className = PatientData[row].Status;
            return td;
        }

        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML              
            if (PatientData[row].RemarkStatus != "") {
                MyStr = MyStr + '<img src="../../Images/Remark.jpg" style="width:20px; Height:25px" alt=' + PatientData[row].RemarkStatus + '/>';

            }
            if (PatientData[row].Urgent == 'Y') {
                MyStr = MyStr + '<img title="Urgent" src="../../Images/urgent.gif"/>';
            }
            if (PatientData[row].TATDelay == "1") {
                MyStr = MyStr + '<img title="TATDelay" src="../../Images/tatdelay.gif" />';
            }
            if (PatientData[row].CombinationSample == "1") {
                MyStr = MyStr + '<img onclick="showmsgCombinationSample(\'' + PatientData[row].CombinationSampleDept + '\')" title="' + PatientData[row].CombinationSampleDept + '" src="../../Images/Red.jpg" style="width:13px; Height:13px;border-radius: 10px;"  />';
            }
            if (PatientData[row].Comments != "") {
                MyStr = MyStr + '<img title="Comments" src="../../Images/comments.png" style="width:25px;height:25px;" alt="Comments" />';
            }

            if (PatientData[row].SampleLocation != '')
                td.innerHTML = MyStr + '<br/>' + PatientData[row].SampleLocation;
            else
                td.innerHTML = MyStr;

            td.className = PatientData[row].Status;

            if (PatientData[row].Status == "Received" && PatientData[row].isrerun == "1") {
                $(td).parent().addClass('FullRowColorInRerun');

            }
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
                td.innerHTML = '<a href="printLabReport_pdf.aspx?IsPrev=1&TestID=' + PatientData[row].Test_ID + ',&Phead=0" target="_blank" > <img  src="../../Images/print.gif" style="border-style: none" alt="">     </a>';
                //  td.id = value.replace(/,/g, "_");
            }
            else {
                td.innerHTML = '<span>&nbsp;</span>';
            }
            td.className = PatientData[row].Status;
            return td;
        }
        function SampleStatusRenderer(instance, td, row, col, prop, value, cellProperties) {
            if (PatientData[row].BarcodeNo != "") {
                td.innerHTML = '<img  src="../../Images/view.gif" style="border-style: none;cursor:pointer;" alt="" onclick="callSampleStatusRenderer(' + "'" + '' + PatientData[row].BarcodeNo + "'" + ');">';
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
            td.innerHTML = '<a target="_blank" id="aa" href="SampleCollectionPatient.aspx?LedgerTransactionNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../Images/Sample.png" style="border-style: none" alt="">     </a>';
            //td.id = value.replace(/,/g, "_");
            // td.style.background = PatientData[row].Status;
            return td;
        }
        function RemarksFieldRenderer(instance, td, row, col, prop, value, cellProperties) {
            // var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            //  td.innerHTML = '<a target="_blank" id="cc" class="iframe Remark" href="../OPD/AddRemarks_PatientTestPopup.aspx?TestID=' + PatientData[row].Test_ID + '&Name=' + PatientData[row].PName + '&LabNo=' + PatientData[row].LedgerTransactionNo + '"  > <img  src="../../Images/edit.png" style="border-style: none" alt="">     </a>';
            //td.id = value.replace(/,/g, "_");
            td.innerHTML = '<input type="text" onkeydown="SaveRemarksStatus(event,this);" id="' + PatientData[row].Test_ID + '#' + PatientData[row].LedgerTransactionNo + '" heght="150px;" value="' + PatientData[row].RemarkStatus + '">';
            td.className = PatientData[row].Status;
            return td;
        }
        function RemarksRenderer(instance, td, row, col, prop, value, cellProperties) {
            if (LabObservationData[row].Inv == "1") {
                if (LabObservationData[row].Remarks == "0") {
                    td.innerHTML = '<img src="../../Images/ButtonAdd.png" style="border-style: none;cursor:pointer;" onclick="AddRemarksOnpopup(\'' + LabObservationData[row].LedgerTransactionNo + '\',\'' + LabObservationData[row].Test_ID + '\',\'' + LabObservationData[row].LabObservationName + '\')">';
                }
                else {
                    td.innerHTML = '<img src="../../Images/RemarksAvailable.jpg" style="border-style: none;cursor:pointer;" onclick="AddRemarksOnpopup(\'' + LabObservationData[row].LedgerTransactionNo + '\',\'' + LabObservationData[row].Test_ID + '\',\'' + LabObservationData[row].LabObservationName + '\')">';
                }
                return td;
            }
            else {
                td.innerHTML = '';
                return td;
            }
        }
        function callSampleStatusRenderer(barcodeno) {
            var href = "../Lab/SampleTracking.aspx?barcodeno=" + barcodeno;
            $.fancybox({
                maxWidth: 860,
                maxHeight: 800,
                fitToView: false,
                width: '80%',
                height: '70%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
            );
        }
        function CallFancyBox() {
            //$(".various").fancybox();
            //$(".Remark").fancybox();
         
            $("#btnPatientHistory").click(function () {
                $("#various2").attr('href', '../CPOE/Investigation.aspx?PID=' + PatientData[currentRow].PatientID);
                $("#various2").fancybox({
                    maxWidth: 1560,
                    maxHeight: 1500,
                    fitToView: false,
                    width: '100%',
                    height: '100%',
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                });
                $("#various2").trigger('click');
            });

            $("a.various").fancybox({
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
                maxWidth: 1360,
                maxHeight: 1200,
                fitToView: false,
                width: '100%',
                height: '90%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
            $("a.ShowAttachment").fancybox({
                maxWidth: 1250,
                maxHeight: 1250,
                fitToView: false,
                width: '90%',
                height: '90%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
            //  $('#fancybox-content').css('padding-top', '15px');
            $('#fancybox-content').css('height', '500px');
            $('#fancybox-content').css('overflow-y', 'auto');

        }
        function ManageSampleStatus(row) {
            window.open('SampleCollectionPatient.aspx?LedgerTransactionNo=' + PatientData[row].LedgerTransactionNo, '_blank')
        }
        function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {

                    <%if (Util.GetString(Request.QueryString["cmd"]) != "changebarcode")
                      {%>
                    var escaped = Handsontable.helper.stringify(value);
                    //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
                    //td.innerHTML = '<a href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> <img  src="../../Images/Post.gif" style="border-style: none" alt="">     </a>';
                    td.innerHTML = '<a style="font-weight:bold;" href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> ' + PatientData[row].BarcodeNo + '     </a>';
                    td.id = value;//.replace(/,/g, "_");
                    //td.style.backgroundColor = "none";
                    $(td).addClass(cellProperties.className);
                    <%}
                      else
                      {%>
                    td.innerHTML = PatientData[row].BarcodeNo;
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
                    //alert(PatientData[rowIndex].ReportType);
                    $('#spInvestigationName').html(PatientData[rowIndex].InvestigationName);
                    rowIndx = rowIndex;
                    //$("#divPatient tr > td").css("background", "#ffffff");
                    //$("#divPatient tr:nth-child(" + (rowIndex+1) + ") > td").css("background", "rgb(189, 245, 245)");
                    //ExitFullScreen();
                    currentRow = rowIndex;
                    // hot1.selectCell(currentRow + 1, 0);
                    // hot1.selectCell(currentRow, 0);
                    //console.log(rowIndex + 1);
                    if (PatientData[rowIndex].ReportType == 5) {
                        IsRadiology = true;
                        $('#divInvestigation').html('');
                        $('#divRadiologyEditor').show();
                $('.divFinding').find('input[type=text]').val('');
                $('.divFinding').show('');
                    }
                    else {
                        IsRadiology = false;
                        $('#divRadiologyEditor').hide();
                $('.divFinding').hide('');
                    }
                    $('#MainInfoDiv').show();
                    $('#divPatient').hide();
                    $('.btnDiv').show();
                    $('#SelectedPatientinfo').show();
                    _test_id = PatientData[rowIndex].Test_ID;
                    _barcodeno = PatientData[rowIndex].BarcodeNo;
                    searchLabObservation(rowIndex, PatientData[rowIndex].PatientID, PatientData[rowIndex].ClinicWard, PatientData[rowIndex].PName, PatientData[rowIndex].Age_Gender, PatientData[rowIndex].LedgerTransactionNo, PatientData[rowIndex].Test_ID, PatientData[rowIndex].Gender, PatientData[rowIndex].AGE_in_Days);
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
                var IsRadiology = false;
                var ModalRow = '';
                var ModalValue = '';
                function searchLabObservation(_index,uhid,clinicward, pname, age_gender, labNo, testId, gender, ageInDays) {
                    TestIdtoPrint = "";
                    //$.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
                    $('.demo').attr('disabled', true);
                    var macId = $('#<%=ddlTestDon.ClientID %> option:selected').val();
                    LedgerTransactionNo = labNo;
                    LoadInvName(LedgerTransactionNo);
                    $('#SelectedPatientinfo').html('');
                    $('#SelectedPatientinfo').append('' +
                        '<table id="tblPatientInfo"><tr><th>Barcode No:</th><td id="PatientBarcodeNo">' + PatientData[_index].BarcodeNo + '</td><th>Patient Name:</th><td>' + pname + '</td><th>Age/Gender:</th><td>' + age_gender + '</td><th>UHID:</th><td>' + uhid + '</td><th>Clinic/Ward:</th><td>' + clinicward + '</td></tr>' +
                        '</table>');
                    $('#divInvestigation').html('');
                    $.ajax({
                        url: "MachineResultEntry.aspx/LabObservationSearch",
                        data: '{LabNo:"' + labNo + '",TestID:"' + testId + '",AgeInDays:' + ageInDays + ',RangeType:"Normal",Gender:"' + gender + '",MachineID:"' + $('#<%=ddlMachine.ClientID%>').val() + '",macId:"' + macId + '"}',
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: true,
                        renderAllRows: true,
                        mergeCells: true,
                        success: function (result) {
                           // TestIdtoPrint = "";
                            $('.SampleStatus').hide();
                            $('#btnPreLabObs').attr("disabled", false);
                            $('#btnNextLabObs').attr("disabled", false);
                            LabObservationData = $.parseJSON(result.d);

                            if (LabObservationData == "-1") {
                                $('.btnForSearch').attr("disabled", true);
                                // $.unblockUI();
                                modelAlert('Your Session Expired.... Please Login Again');
                                return;
                            }
                            if (LabObservationData.length == 0) {
                                $('.btnForSearch').attr("disabled", true);
                                // $.unblockUI();
                                // $("#<%=lblMsg.ClientID %>").text('No Record Found');
                                modelAlert('No Record Found');
                                return;
                            }
                            else {
                                UpdateSampleStatus();
                                $('.demo').attr('disabled', false);
                                $('.SampleStatus').attr('disabled', false);
                                $("#<%=lblMsg.ClientID %>").text('');
                              
                                //TestIdtoPrint = LabObservationData[2].TestIDGrouped;
                                var data = LabObservationData,
                                 container2 = document.getElementById('divInvestigation');
                                hot2 = new Handsontable(container2, {
                                    data: LabObservationData,
                                    colHeaders: [
                                         "#", "Test", "Value", "Comment", "Flag", "Delta Value", "MacReading", "ReadingFormat", "MinValue", "MaxValue", "Machine Name", "Reading1", "Reading2", " ", "Method Name", "Display Reading", "Remarks", "MinCritical", "MaxCritical"
                                    ],
                                    columns: [
                                         {
                                             data: 'SaveInv',
                                             renderer: CheckBoxrender,

                                             readOnly: false, width: 30
                                         },
                                    { data: 'LabObservationName', renderer: LabObservationRender, width: 300 },
                                    { data: 'Value', readOnly: false, renderer: CheckCellValue, width: 150 },
                                    { renderer: ShowComment },
                                    //{ data: 'Flag', renderer: renderFlag },

                                    {
                                        data: 'Flag',
                                        type: 'dropdown',
                                        source: ['Normal', 'High', 'Low', ''],
                                        width: 80,
                                        readOnly: true,
                                        renderer: changeColor
                                    },
                                    { data: 'oldvalues', width:250 },
                                   // { data: 'Value1' },
                                    { data: 'MacReading' },
                                    


                                    { data: 'ReadingFormat', readOnly: true },
                                    { data: 'MinValue', readOnly: true },
                                    { data: 'MaxValue', readOnly: true },
                                    { data: 'machinename' },
                                    { data: 'Value1' },
                                    { data: 'Value2' },// , renderer: safeHtmlRenderer 
                                    {
                                        data: 'PrintMethod',
                                        type: 'checkbox',
                                        checkedTemplate: '1',
                                        uncheckedTemplate: '0',
                                        readOnly: false
                                    },
                                    { data: 'Method', readOnly: true },
                                    { data: 'DisplayReading', readOnly: true },
                                    { data: 'Remarks', renderer: RemarksRenderer },
                                    { data: 'MinCritical', readOnly: true },
                                    { data: 'MaxCritical', readOnly: true }

                                    ],
                                    stretchH: "all",
                                    autoWrapRow: false,
                                    manualColumnFreeze: true,
                                    rowHeaders: true,
                                    readOnly: true,
                                    fillHandle: false,
                                    rowHeaders: false,
                                    renderAllRows: true,
                                    beforeChange: function (change, source) {
                                        updateFlag(change);

                                    },

                                    cells: function (row, col, prop) {
                                       
                                        //if (LabObservationData[row].IsComment == "0") {
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

                                                //if (LabObservationData[row].helpvalueonly == "0") {
                                                this.strict = false;
                                                this.allowInvalid = false;
                                                //}
                                                //else {
                                                //    this.strict = false;
                                                //}
                                            }
                                            catch (e) {
                                            }
                                        }
                                        //}
                                        if (LabObservationData[row].IsComment == "1") {
                                            this.readOnly = true;
                                        }

                                        if (LabObservationData[row].ReportType != "1") {

                                            this.readOnly = true;

                                        }
                                        if (LabObservationData[row].Inv == "3") {
                                            this.readOnly = true;
                                        }
                                        if (LabObservationData[row].Inv == "2") {
                                            this.readOnly = false;
                                        }

                                        if (LabObservationData[row].LabObservationName == "Comments" && prop === 'Value') {
                                            var Commentval = LabObservationData[row].Value;
                                            try {
                                                this.type = 'autocomplete';
                                                this.source = ['', 'Result Rechecked'];
                                            }
                                            catch (e) {
                                            }
                                        }
                                        if (LabObservationData[row].ReportType == "5") {
                                            IsRadiology = true;
                                            ModalRow = row;
                                            ModalValue = LabObservationData[row].Description;
                                            RTest_Id = LabObservationData[row].Test_ID;

                                        }
                                    }
                                });
                                ApplyFormula();
                                hot2.selectCell(0, 1);

                                // $.unblockUI();
                                $('.btnForSearch').attr("disabled", false);
                                if (IsRadiology) {
                                    IsRadiology = false;
                                    $('#divInvestigation').html('');
                                    $('#divRadiologyEditor').show();
                                    $('.divFinding').find('input[type=text]').val('');
                                    $('.divFinding').show();
                                    $('.DivInvName').show();
                                    $('[id$=Button5]').hide();

                                    CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData(ModalValue);
                                    //----------------------

                                    $.ajax({
                                        url: "MachineResultEntry.aspx/Getpatient_labobservation_opd_text",
                                        async: true,
                                        data: '{TestId:"' + RTest_Id + '",BarcodeNo:""}',
                                        contentType: "application/json; charset=utf-8",
                                        type: "POST", // data has to be Posted 
                                        timeout: 120000,
                                        dataType: "json",
                                        success: function (result) {
                                            CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData((result.d).split('$')[0]);
                                            $('#txtFinding').val((result.d).split('$')[1]);
                                        }
                                    });

                                        loadObservationComment(ModalRow, "", "Value", "");
                                    //-----------------------
                                    } else {
                                    // $('[id$=Button5]').show();
                                        $('#divRadiologyEditor').hide();
                                    }

                                }
                        },
                        error: function (xhr, status) {
                            // $.unblockUI();
                            $('#divInvestigation').html('');
                            modelAlert('Error occured..');
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                    }

        function LoadInvName(LabNo) {
         //   $('.divFinding').find('input[type=text]').val('');
                        $.ajax({
                            url: "MachineResultEntry.aspx/GetPatientInvsetigationsNameOnly",
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
                                // alert("Error.... ");
                                window.status = status + "\r\n" + xhr.responseText;
                            }
                        });
                    }

                    function checkme(ctrl) {
                        var morecheckbox = $(ctrl).attr("class");
                        if ($(ctrl).is(":checked")) {
                            $('.' + morecheckbox).attr('checked', true);
                            for (var i = 0; i < LabObservationData.length; i++) {

                                if (LabObservationData[i].Inv != "3" && LabObservationData[i].Test_ID == morecheckbox) {
                                    LabObservationData[i].SaveInv = "true";
                                }
                            }

                        }
                        else {
                            $('.' + morecheckbox).attr('checked', false);

                            for (var i = 0; i < LabObservationData.length; i++) {

                                if (LabObservationData[i].Inv != "3" && LabObservationData[i].Test_ID == morecheckbox) {
                                    LabObservationData[i].SaveInv = "false";
                                }
                            }
                        }
                    }

                    function CheckBoxrender(instance, td, row, col, prop, value, cellProperties) {
                        if (LabObservationData[row].Inv == "1") {
                            td.innerHTML = "<input onclick='checkme(this)' class= '" + LabObservationData[row].Test_ID + "' type='checkbox' checked='" + value + "'/> ";
                        }
                        if (LabObservationData[row].Inv != "1" && LabObservationData[row].Inv != "3") {
                            td.innerHTML = "<input class= '" + LabObservationData[row].Test_ID + "' type='checkbox' disabled='disabled'  checked='" + value + "' /> ";
                        }
                        if (LabObservationData[row].Inv == "3") {
                            td.innerHTML = "";
                        }
                        return td;
                    }
                   // var TestIdtoPrint="";
                    function LabObservationRender(instance, td, row, col, prop, value, cellProperties) {
                        if (LabObservationData[row].Inv == "1") {
                            if (LabObservationData[row].IsAttached != "") {
                                //td.innerHTML = '<span title="' + value + '" style=" white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">' + value + '</span><br/>' + LabObservationData[row].IsAttached;
                                //if (elt.options[elt.selectedIndex].text == "Pending" || elt.options[elt.selectedIndex].text == "ReRun" || elt.options[elt.selectedIndex].text == "Tested" || elt.options[elt.selectedIndex].text == "Machine Data") {
                                if (LabObservationData[row].pliIsReRun != 2) {
                                    td.innerHTML = value + '<br/>' + LabObservationData[row].IsAttached + '<br/><input style="cursor:pointer;" class="ItDoseButton" type="button" value="ReRun" onclick="$showRerunModel(\'' + LabObservationData[row].PLIID + '\',\'' + LabObservationData[row].pliIsReRun + '\' )"/>';
                                }
                                else {
                                    td.innerHTML = value + '<br/>' + LabObservationData[row].IsAttached;
                                }
                            }
                            else {
                                //td.innerHTML = '<span title="' + value + '" style=" white-space: nowrap;overflow: hidden;text-overflow: ellipsis;position: absolute;left: 0; right: 0;">' + value + '</span>';
                                //td.innerHTML = '<span title="' + value + '" style=" white-space: nowrap;overflow: hidden;text-overflow: ellipsis;position: absolute;left: 0; right: 0;">' + value + '</span>';
                                if (LabObservationData[row].pliIsReRun != 2) {
                                    td.innerHTML = value + '<br/><input type="button" onclick="$showRerunModel(\'' + LabObservationData[row].PLIID + '\',\'' + LabObservationData[row].pliIsReRun + '\' )" style="cursor:pointer;"  type="button" value="ReRun"/>';
                                }
                                else {
                                    td.innerHTML = value;
                                }
                            }
                        }

                        else {
                            //td.innerHTML = '<span title="' + value + '" style=" white-space: nowrap;overflow: hidden;text-overflow: ellipsis;position: absolute;left: 0; right: 0;">' + value + '</span>';
                            td.innerHTML = value;
                        }
                        td.style.background = LabObservationData[row].Status;
                        td.style.width = '300px';
                        //td.style.position = 'relative';
                        if (LabObservationData[row].Inv == "1") {
                            //td.setAttribute("colSpan", "15");
                            if (value.indexOf("(RERUN)") >= 0) {
                                td.setAttribute("style", "background-color:#F781D8;");
                            }
                            else {

                                $(td).parent().addClass('InvHeader');
                            }
                            //TestIdtoPrint = TestIdtoPrint + "," + LabObservationData[row].Test_ID;
                            //td.setAttribute("style", "background-color:" + LabObservationData[row].Status);
                        }
                        else if (LabObservationData[row].Inv == "3")
                            $(td).parent().addClass('DeptHeader');
                        if (LabObservationData[row].Value == "HEAD") {
                            //td.setAttribute("colSpan", "15");
                            $(td).parent().addClass('InvSubHead');
                        }
                        if (LabObservationData[row].Inv == "0") {
                            $(td).parent().removeClass('InvHeader');
                            $(td).parent().removeClass('DeptHeader');
                        }
                        //$(td).parent().removeClass('FullRowColorInPink');
                        //$(td).parent().removeClass('FullRowColorInYellow');
                        return td;
                    }
                    var $rerunTestData = null;
                    $showRerunModel = function (TestID, isTestRerun) {
                        console.log(TestID);
                        console.log(isTestRerun);
                        $rerunTestData = null;
                        $('#divRerunTest').showModel();
                        $('#txtRemarks').focus();
                        $rerunTestData = {
                            test_ID: TestID,
                            isTestRerun: isTestRerun
                        }
                    }

                    $rerunLabTest = function (rerunReason) {
                        if (rerunReason.reason != '') {
                            serverCall('../../Design/common/CommonService.asmx/RerunLabTest', { test_ID: $rerunTestData.test_ID, isTestRerun: $rerunTestData.isTestRerun, reason: rerunReason.reason }, function (response) {
                                var $responseData = JSON.parse(response);
                                if ($responseData.status) {
                                    modelAlert($responseData.response, function () {
                                        window.location.reload();
                                    });
                                }
                                else {
                                    modelAlert($responseData.response, function () { });
                                }
                            });
                        }
                        else {
                            modelAlert('Enter Re-Run Reason');
                        }
                    }
                    function CheckCellValue(instance, td, row, col, prop, value, cellProperties) {
                        //  alert(LabObservationData[row].Inv);
                        if ((LabObservationData[row].Inv == "1") || (LabObservationData[row].Inv == "3")) {
                            cellProperties.readOnly = true;
                            td.innerHTML = '';
                            return td;
                        }
                        else if (LabObservationData[row].Inv == "4") {
                            cellProperties.readOnly = true;
                            td.innerHTML = value;
                            return td;
                        }
                        else if (LabObservationData[row].Inv == "2") {
                            cellProperties.readOnly = false;
                            td.innerHTML = value;
                            return td;
                        }
                        if (LabObservationData[row].IsComment == "0") {
                            if (value == 'HEAD' || elt.options[elt.selectedIndex].text == "Approved" || LabObservationData[row].IsSampleCollected != 'Y') {
                                cellProperties.readOnly = true;
                            } else {
                                cellProperties.readOnly = false;
                            }
                            td.innerHTML = value;
                        }
                        else if (LabObservationData[row].IsComment == "1") {
                            if (LabObservationData[row].Value == "")
                                td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'Comment\',\'' + (value == "" ? null : value) + '\');"><img src="../../Images/ButtonAdd.png"/></span>';
                            if (LabObservationData[row].Value != "")
                                td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'Comment\',\'\');"><img src="../../Images/Redplus.png"/></span>';
                        }
                        //if (LabObservationData[row].LabObservationName == "ORGANISMS")//organism page
                        //    td.innerHTML = '<a target="_blank" id="cc" class="iframe Remark" href="LabResultEntryNew_Micro.aspx?TestID=' + LabObservationData[row].Test_ID + '&LabNo=' + LabObservationData[row].LabNo + '&InvId=' + LabObservationData[row].Investigation_ID + '"  > <img  src="../../Images/edit.png" style="border-style: none" alt="">     </a>';
                        //td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../Images/ButtonAdd.png"/></span>';
                        if (LabObservationData[row].ReportType != "1") {
                            td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../Images/ButtonAdd.png"/></span>';

                        }
                        //alert(LabObservationData[row].MacReading);
                        if (LabObservationData[row].MacReading != "" && LabObservationData[row].MacReading != null) {
                            if (LabObservationData[row].Value != LabObservationData[row].MacReading) {
                                // change background color when value differ from macreading
                                td.style.setProperty('background-color', '#FFC133', 'important');
                                //cellProperties.comment = 'Value Not Matching With Machin Value';
                            }
                        }
                        return td;
                    }
                    function changeColor(instance, td, row, col, prop, value, cellProperties) {


                        if (LabObservationData[row].Inv > 0) {
                            td.innerHTML = value;
                            return td;
                        }


                        isRed = 0;
                        isCrictical = 0;

                        var MinRange = LabObservationData[row].MinValue;
                        var MaxRange = LabObservationData[row].MaxValue;
                        var Value = LabObservationData[row].Value;

                        var MinCritical = LabObservationData[row].MinCritical;
                        var MaxCritical = LabObservationData[row].MaxCritical;

                        if (Value == "") {
                            LabObservationData[row].Flag = '';
                            value = '';
                        }
                        else {
                            if (MinRange != "" && MinRange != "null" && MinRange != null) {
                                if (parseFloat(Value) < parseFloat(MinRange.replace("<", "").replace(">", "").replace("=", ""))) {
                                    isRed = 1;
                                    LabObservationData[row].Flag = 'Low';
                                    value = 'Low';

                                 if (MinCritical != "" && MinCritical != "null" && MinCritical != null && MinCritical != "0") {
                                        if (parseFloat(Value) < parseFloat(MinCritical)) {
                                            isCrictical = 1;
                                            LabObservationData[row].Flag = 'Critical_Low';
                                            value = 'Critical_Low';
                                        }
                                    }
                                }                               
                                else {
                                    LabObservationData[row].Flag = 'Normal';
                                    value = 'Normal';
                                }
                            }

                            if (isRed == 0 && MaxRange != "" && MaxRange != "null" && MaxRange != null) {
                                if (parseFloat(Value) > parseFloat(MaxRange.replace("<", "").replace(">", "").replace("=", ""))) {

                                    LabObservationData[row].Flag = 'High';
                                    value = 'High';

                                    if (isCrictical == 0 && MaxCritical != "" && MaxCritical != "null" && MaxCritical != null && MaxCritical != "0") {
                                        if (parseFloat(Value) > parseFloat(MaxCritical)) {
                                            LabObservationData[row].Flag = 'Critical_High';
                                            value = 'Critical_High';
                                        }
                                    }
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
                        else if (value == "Critical_Low") {
                            td.style.background = 'red';
                            $(td).parent().addClass('FullRowColorInRed');
                        }
                        else if (value == "Critical_High") {
                            td.style.background = 'red';
                            $(td).parent().addClass('FullRowColorInRed');
                        }
                        else {
                            td.style.background = '';
                            $(td).parent().removeClass('FullRowColorInPink');
                            $(td).parent().removeClass('FullRowColorInYellow');
                            $(td).parent().removeClass('FullRowColorInRed');
                        }

                        td.innerHTML = value;
                        value = "";
                        return td;
                    }

                    function ShowComment(instance, td, row, col, prop, value, cellProperties) {
                        if (LabObservationData[row].Inv == "1") {
                            if (LabObservationData[2].CancelByInterface == "1" && LabObservationData[2].IsSampleCollected == "Y") {
                                td.innerHTML = '<span style="display:none;" id="cNameid">' + LabObservationData[2].InterfaceCName + '</span><span style="cursor:pointer;height:100px;width:100px;" onmouseover="showCompanyName()" onmouseout="hideCompaneName()"><img style="width:20px;height:20px;" src="../../Images/alert.PNG"/></span>';
                                $(td).parent().addClass('FullRowColorInCancelByInterface');
                            }
                        }
                        else {
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
                            else {
                                if (LabObservationData[row].Description == "" || LabObservationData[row].Description == null || LabObservationData[row].Description == "null") {
                                    td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', ' + prop + ',' + value + ');"><img src="../../Images/ButtonAdd.png"/></span>' + '&nbsp;<span style="cursor:pointer;height:100px;width:100px;" onclick="showdelta(\'' + LabObservationData[row].PLIID + '\',\'' + LabObservationData[row].LabObservation_ID + '\')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../../Images/delta.png"/></span>';
                                }
                                else {
                                    td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', ' + prop + ',' + value + ');"><img src="../../Images/RemarksAvailable.jpg"/></span>' + '&nbsp;<span style="cursor:pointer;height:100px;width:100px;" onclick="showdelta(\'' + LabObservationData[row].PLIID + '\',\'' + LabObservationData[row].LabObservation_ID + '\')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../../Images/delta.png"/></span>';
                                }
                                //td.innerHTML = value + '<br/><span style="cursor:pointer;height:100px;width:100px;" onmouseover="showdelta(' + LabObservationData[row].PLIID + ',' + LabObservationData[row].LabObservation_ID + ')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../OnlineLab/Images/delta.png"/></span>';
                            }
                        }
                        return td;
                    }
                    function ShowModalWindow(row, col, prop, value) {
                        //CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData('');
                    // console.log(LabObservationData[row].Description);
                    if (prop != "Value") {
                        $('#CommentHead').html('Comments');
                        $('#CommentBox').show();
                        $('#sprequiredfile').html('');
                        CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                        $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                        $('#DIVMODELFOOTER').html('<h3 style="height: 10px;">' +
                            '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                            '&nbsp;&nbsp;&nbsp;<div style="float: right;">' +
                            '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',' + prop + ');" class="btnAddComment" style="height: 30px;"/>' +
                            '&nbsp;&nbsp;&nbsp;<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                            '</div></h3>');
                        modal.style.display = "block";


                        loadObservationComment(row, col, prop, value);
                    } else if (prop == "Value") {

                        if (LabObservationData[row].ReportType == "1") {
                            //console.log(prop);
                            $('#CommentBox').hide();
                            CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                            $('.modal_header').html('Set Value');
                            $('#DIVMODELFOOTER').html('<h3 style="height: 10px;">' +
                                '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                                '&nbsp;&nbsp;&nbsp;<div style="float: right;">' +
                                '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                                '&nbsp;&nbsp;&nbsp;<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                                '</div></h3>');

                        }
                        else if (LabObservationData[row].ReportType == "3" || LabObservationData[row].ReportType == "5") {
                            $('#CommentHead').html('Templates');
                            $('#CommentBox').show();
                            $('#sprequiredfile').html(LabObservationData[1].RequiredField);
                            CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                            $('.modal_header').html('Enter Report for ' + LabObservationData[row].LabObservationName);

                            var my = '<h3 style="height: 10px;">';
                            my += '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>';
                        
                            <% if (ApprovalId == "1" || ApprovalId == "3" || ApprovalId == "4")
                        {%>
                            my += '&nbsp;<input type="text" style="width:525px;" placeholder="Template Name" id="txttempname"/> <input type="button" value="Save As Template"  style="height:30px;width300px;cursor:pointer;font-weight:bold;" onclick="saveasTemplate();"/><span id="invid" style="display:none;">' + LabObservationData[row].Investigation_ID + '</span>';

                            <%}%>
                            my += '<div style="float: right;">' +
                                '&nbsp;&nbsp;&nbsp;<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                                '&nbsp;&nbsp;&nbsp;<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                                '</div></h3>';
                             
                           
                            $('#DIVMODELFOOTER').html(my);

                            BindTemplateValue(row, col, prop, value);


                            loadObservationComment(row, col, prop, value);
                        }

                    modal.style.display = "block";
                }
        }

        function saveasTemplate() {
            var commentValue = CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].getData();

                    if (commentValue == "") {
                        //$('#msgField').html('');
                        //$('#msgField').append("Please Enter Something To Save As Template");
                        //$(".alert").css('background-color', 'red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        modelAlert('Please Enter Something To Save As Template');

                        return;

                    }
                    if ($('#txttempname').val() == "") {
                        //$('#msgField').html('');
                        //$('#msgField').append("Please Enter Template Name");
                        //$(".alert").css('background-color', 'red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        modelAlert('Please Enter Template Name');
                        $('#txttempname').focus();
                        return;
                    }
                    var tempname = $('#txttempname').val();
                    var invid = $('#invid').html();
                    $.ajax({
                        url: "MachineResultEntry.aspx/savetemplate",
                        data: JSON.stringify({ temp: commentValue, tempname: tempname, invid: invid }),
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {

                                //$('#msgField').html('');
                                //$('#msgField').append("Template Saved");
                                //$(".alert").css('background-color', '#04b076');
                                //$(".alert").removeClass("in").show();
                                //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                                modelAlert('Template Saved Successfully');
                                $('#txttempname').val('');
                            }
                            else {
                                //$('#msgField').html('');
                                //$('#msgField').append(result.d);
                                //$(".alert").css('background-color', 'red');
                                //$(".alert").removeClass("in").show();
                                //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                                modelAlert(result.d);
                            }
                        },
                        error: function (xhr, status) {
                            modelAlert(xhr.responseText);
                        }
                    });

                }
                function BindTemplateValue(row, col, prop, value) {
                    if (LabObservationData[row].Method == 1)
                        return;
                    $.ajax({
                        url: "MachineResultEntry.aspx/Getpatient_labobservation_opd_text",
                        data: '{ TestId:"' + LabObservationData[row].LabObservation_ID + '",BarcodeNo:"' + LabObservationData[row].BarcodeNo + '"}', // parameter map
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            LabObservationData[row].Method = 1;
                    LabObservationData[row].Description = (result.d).split('$')[0];
                    CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData((result.d).split('$')[0]);
                    $('#txtFinding').val((result.d).split('$')[1]);
                        },
                        error: function (xhr, status) {
                            //alert("Error.... ");
                        }
                    });
                }
                function loadObservationComment(row, col, prop, value) {
                    $('#ddlCommentsLabObservation').attr('title', prop);
                    $('#ddlCommentsLabObservation1').attr('title', prop);

                    $.ajax({

                        url: "MachineResultEntry.aspx/Comments_LabObservation",
                        data: '{ LabObservation_ID:"' + LabObservationData[row].LabObservation_ID + '",Type:"' + prop + '"}', // parameter map
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            result = $.parseJSON(result.d);
                            $("#ddlCommentsLabObservation").empty();
                            $("#ddlCommentsLabObservation").append("<option value=''>Select</option>");
                            $("#ddlCommentsLabObservation1").empty();
                            $("#ddlCommentsLabObservation1").append("<option value=''>Select</option>");
                            if (prop == 'Value') {
                                for (var i = 0; i < result.length; i++) {
                                    var newOption = "<option value=" + result[i].Template_ID + "#" + LabObservationData[row].Test_ID + ">" + result[i].Temp_Head + "</option>";
                                    $("#ddlCommentsLabObservation").append(newOption);
                                    $("#ddlCommentsLabObservation1").append(newOption);
                                }
                            }
                            else {
                                for (var i = 0; i < result.length; i++) {
                                    var newOption = "<option value=" + result[i].Comments_ID + ">" + result[i].Comments_Head + "</option>";
                                    $("#ddlCommentsLabObservation").append(newOption);
                                    $("#ddlCommentsLabObservation1").append(newOption);
                                }
                            }
                        },
                        error: function (xhr, status) {
                            //alert("Error.... ");
                        }
                    });

                }


                function ddlCommentsLabObservation_Load(CommentID) {
                    var BarcodeNo = $('#tblPatientInfo tr > td#PatientBarcodeNo').html();
                    var Test_ID = CommentID.split('#')[1];
                    var type = $('#ddlCommentsLabObservation').attr('title');
                    $.ajax({
                        url: "MachineResultEntry.aspx/GetComments_labobservation",
                        data: '{ CmntID:"' + CommentID + '",type:"' + type + '",BarcodeNo:"' + BarcodeNo + '",Test_ID:"' + Test_ID + '"}', // parameter map
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(result.d);

                        },
                        error: function (xhr, status) {
                            //alert("Error.... ");
                        }
                    });

                    }

                    function ddlCommentsLabObservation1_Load(CommentID) {
                        var BarcodeNo = $('#tblPatientInfo tr > td#PatientBarcodeNo').html();
                        var Test_ID = CommentID.split('#')[1];
                        var type = $('#ddlCommentsLabObservation1').attr('title');
                        $.ajax({
                            url: "MachineResultEntry.aspx/GetComments_labobservation",
                            data: '{ CmntID:"' + CommentID + '",type:"' + type + '",BarcodeNo:"' + BarcodeNo + '",Test_ID:"' + Test_ID + '"}', // parameter map
                            type: "POST", // data has to be Posted    	        
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData(result.d);

                },
                error: function (xhr, status) {
                    //alert("Error.... ");
                }
            });

            }

            function ClearComment()
            { CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(''); }
                function CancelComment()
                { modal.style.display = "none"; }
                function AddComment(rowValue, prop) {
                    var commentValue = CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].getData();
                    //if (prop == 'Value') {

                    //    LabObservationData[rowValue].Value = commentValue;
                    //}
                    //else {

                    //    LabObservationData[rowValue].Description = commentValue;
                    //}
                    LabObservationData[rowValue].Description = commentValue;
                    if (LabObservationData[rowValue].IsComment == 1) {
                        //LabObservationData[rowValue].Description = commentValue;
                        //LabObservationData[rowValue].Value = 'Reported';

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
                    ApplyBloodGroupFormula();
                    try {
                        ApplyEGFRFormula();
                    }
                    catch (e) {
                    }
                }
                function ApplyFormula() {

                    for (var i = 0; i < LabObservationData.length; i++) {


                        if (LabObservationData[i].Inv == '0') {
                            //console.log(LabObservationData[i].LabObservation_ID.Value);
                            LabObservationData[i].isCulture = LabObservationData[i].Formula;

                            if (LabObservationData[i].isCulture != '') {
                                for (var j = 0; j < LabObservationData.length; j++) {
                                    try {
                                        // debugger;
                                        if (LabObservationData[j].Inv == '0')
                                            LabObservationData[i].isCulture = LabObservationData[i].isCulture.replace((LabObservationData[j].LabObservation_ID + "@"), LabObservationData[j].Value);
                                        //              console.log(LabObservationData[i].isCulture);
                                    }
                                    catch (e) {
                                    }

                                }

                                try {
                                    var _salek = eval(LabObservationData[i].isCulture);
                                    // alert(_salek);
                                    if (_salek != '')
                                        LabObservationData[i].Value = Math.round(_salek * 100) / 100;
                                    else
                                        LabObservationData[i].Value = "";

                                } catch (e) { LabObservationData[i].Value = '' }
                                var ans = LabObservationData[i].Value;
                                if ((isNaN(ans)) || (ans == "Infinity")) {
                                    LabObservationData[i].Value = '';
                                }
                            }
                        }
                    } hot2.render();
                }
                var AntiA = "";
                var AntiB = "";
                var ACells = "";
                var BCells = "";
                var OCells = "";
                var AntiD = "";

                function ApplyBloodGroupFormula() {

                    for (var i = 0; i < LabObservationData.length; i++) {
                        if (LabObservationData[i].Inv == '0' && LabObservationData[i].Investigation_ID == '25') {


                            if (LabObservationData[i].LabObservation_ID == "1339") {
                                AntiA = LabObservationData[i].Value;
                            }
                            if (LabObservationData[i].LabObservation_ID == "1340") {
                                AntiB = LabObservationData[i].Value;
                            }
                            if (LabObservationData[i].LabObservation_ID == "1343") {
                                ACells = LabObservationData[i].Value;
                            }
                            if (LabObservationData[i].LabObservation_ID == "1344") {
                                BCells = LabObservationData[i].Value;
                            }
                            if (LabObservationData[i].LabObservation_ID == "1345") {
                                OCells = LabObservationData[i].Value;
                            }
                            if (LabObservationData[i].LabObservation_ID == "1341") {
                                AntiD = LabObservationData[i].Value;
                            }

                            //Under Six Month
                            if (LabObservationData[i].AgeInDays <= 180) {
                                //Case +	-	-	+	-	+  (A POSITIVE)
                                if (AntiA == "+" && AntiB == "-" && AntiD == "+") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "A";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "POSITIVE";
                                    }
                                }


                                    //Case 2 +	-	-	+	-	- (A NEGATIVE)
                                else if (AntiA == "+" && AntiB == "-" && AntiD == "-") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "A";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "NEGATIVE";
                                    }
                                }
                                    //Case 3 -	+	+	-	-	+ (B POSITIVE)
                                else if (AntiA == "-" && AntiB == "+" && AntiD == "+") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "B";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "POSITIVE";
                                    }
                                }
                                    //Case 4 -	+	+	-	-	- (B NEGATIVE)
                                else if (AntiA == "-" && AntiB == "+" && AntiD == "-") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "B";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "NEGATIVE";
                                    }
                                }
                                    //Case 5 +	+	-	-	-	+ (AB POSITIVE)
                                else if (AntiA == "+" && AntiB == "+" && AntiD == "+") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "AB";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "POSITIVE";
                                    }
                                }
                                    //Case 6 +	+	-	-	-	- (AB NEGATIVE)
                                else if (AntiA == "+" && AntiB == "+" && AntiD == "-") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "AB";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "NEGATIVE";
                                    }
                                }
                                    //Case 7 -	-	+	+	-	+ (O POSITIVE)
                                else if (AntiA == "-" && AntiB == "-" && AntiD == "+") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "O";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "POSITIVE";
                                    }
                                }
                                    //Case 8 -	-	+	+	-	- (O NEGATIVE)
                                else if (AntiA == "-" && AntiB == "-" && AntiD == "-") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "O";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "NEGATIVE";
                                    }
                                }
                                else {
                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "";
                                    }
                                }
                            }
                                //Over Six Month
                            else {

                                //Case +	-	-	+	-	+  (A POSITIVE)
                                if (AntiA == "+" && AntiB == "-" && ACells == "-" && BCells == "+" && OCells == "-" && AntiD == "+") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "A";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "POSITIVE";
                                    }
                                }


                                    //Case 2 +	-	-	+	-	- (A NEGATIVE)
                                else if (AntiA == "+" && AntiB == "-" && ACells == "-" && BCells == "+" && OCells == "-" && AntiD == "-") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "A";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "NEGATIVE";
                                    }
                                }
                                    //Case 3 -	+	+	-	-	+ (B POSITIVE)
                                else if (AntiA == "-" && AntiB == "+" && ACells == "+" && BCells == "-" && OCells == "-" && AntiD == "+") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "B";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "POSITIVE";
                                    }
                                }
                                    //Case 4 -	+	+	-	-	- (B NEGATIVE)
                                else if (AntiA == "-" && AntiB == "+" && ACells == "+" && BCells == "-" && OCells == "-" && AntiD == "-") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "B";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "NEGATIVE";
                                    }
                                }
                                    //Case 5 +	+	-	-	-	+ (AB POSITIVE)
                                else if (AntiA == "+" && AntiB == "+" && ACells == "-" && BCells == "-" && OCells == "-" && AntiD == "+") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "AB";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "POSITIVE";
                                    }
                                }
                                    //Case 6 +	+	-	-	-	- (AB NEGATIVE)
                                else if (AntiA == "+" && AntiB == "+" && ACells == "-" && BCells == "-" && OCells == "-" && AntiD == "-") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "AB";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "NEGATIVE";
                                    }
                                }
                                    //Case 7 -	-	+	+	-	+ (O POSITIVE)
                                else if (AntiA == "-" && AntiB == "-" && ACells == "+" && BCells == "+" && OCells == "-" && AntiD == "+") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "O";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "POSITIVE";
                                    }
                                }
                                    //Case 8 -	-	+	+	-	- (O NEGATIVE)
                                else if (AntiA == "-" && AntiB == "-" && ACells == "+" && BCells == "+" && OCells == "-" && AntiD == "-") {

                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "O";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "NEGATIVE";
                                    }
                                }
                                else {
                                    if (LabObservationData[i].LabObservation_ID == "933") {
                                        LabObservationData[i].Value = "";
                                    }
                                    if (LabObservationData[i].LabObservation_ID == "934") {
                                        LabObservationData[i].Value = "";
                                    }
                                }
                            }
                        }
                    }
                }
                function ApplyEGFRFormula() {

                    var mmvalue = '';
                    for (var i = 0; i < LabObservationData.length; i++) {
                        //console.log(LabObservationData[i].Investigation_ID);
                        if (LabObservationData[i].LabObservation_ID == '<%=GetLocalResourceObject("CREATININE_ObservationID")%>' && LabObservationData[i].Value != '') {

                    //Female 143.5*((CREATININE/0.7)^-0.329)*((0.993)^AgeInYear) = 129.34  if CREATININE less then 0.7

                    var CREATININE = LabObservationData[i].Value;
                    var AgeInYear = LabObservationData[i].AgeInDays / 365;
                    if (LabObservationData[i].Gender == "Female") {
                        var a = CREATININE / 88.4;
                        var b = Math.pow(a, (-1.154));

                        var c = Math.pow(AgeInYear, (-0.203));
                        mmvalue = 186 * b * c * 0.742;
                    }

                    //Female 143.5*((CREATININE/0.7)^-1.209)*((0.993)^AgeInYear)  if CREATININE greater then 0.7
                    //if (LabObservationData[i].Gender == "Female" && parseFloat(LabObservationData[i].Value) >= 0.7) {
                    //    var a = CREATININE / 0.7;
                    //    var b = Math.pow(a,(-1.209));
                    //    var c = Math.pow(0.993 ,AgeInYear);
                    //    mmvalue =143.5 * b * c;
                    //}

                    //Male 141*((CREATININE/0.9)^-0.411)*((0.993)^AgeInYear)   if CREATININE Less Then  0.9
                    if (LabObservationData[i].Gender == "Male") {
                        var a = CREATININE / 88.4;
                        var b = Math.pow(a, (-1.154));

                        var c = Math.pow(AgeInYear, (-0.203));
                        mmvalue = 186 * b * c;
                    }
                    //cre 96
                    //egfr 89.5
                    //Male 141*((CREATININE/0.9)^-1.209)*((0.993)^AgeInYear)   if CREATININE greater Then  0.9
                    //if (LabObservationData[i].Gender == "Male" && parseFloat(LabObservationData[i].Value) >= 0.9) {
                    //    var a = CREATININE / 0.9;
                    //    var b = Math.pow(a, (-1.209));

                    //    var c = Math.pow(0.993, AgeInYear);
                    //    mmvalue = 141 * b * c;
                    //}

                }

                if (LabObservationData[i].LabObservation_ID == '<%=GetLocalResourceObject("eGFR_ObservationID")%>') {
                    LabObservationData[i].Value = mmvalue.toFixed(2);
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
                        url: "MachineResultEntry.aspx/BindTestToForward",
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
                        },
                        error: function (xhr, status) {
                        }
                    });


                    $("#<%=ddlcentre.ClientID %> option").remove();
                    var ddlcentre = $("#<%=ddlcentre.ClientID %>");
                    $.ajax({
                        url: "MachineResultEntry.aspx/BindCentreToForward",
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
                    $('#ModalPopupExtender2').show();
                }

                function binddoctoforward() {
                    $("#<%=ddlforward.ClientID %> option").remove();
                    var ddlforward = $("#<%=ddlforward.ClientID %>");
                    $.ajax({
                        url: "MachineResultEntry.aspx/BindDoctorToForward",
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
                        modelAlert('Please Select Test');
                        $("#<%=ddltest.ClientID %>").focus();
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
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);]
                        modelAlert('Please Select Doctor to Forward');
                        $("#<%=ddlforward.ClientID %>").focus();
                        return;
                    }


                    $.ajax({
                        url: "MachineResultEntry.aspx/ForwardMe",
                        data: '{testid:"' + $('#<%=ddltest.ClientID%> option:selected').val() + '" ,centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '",forward:"' + $('#<%=ddlforward.ClientID%> option:selected').val() + '", MobileApproved:0,MobileEMINo:"", MobileNo: "", MobileLatitude: "", MobileLongitude: ""}', // parameter map 
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            if (result.d == "1") {
                                //  $('#msgField').html('');
                                //  $('#msgField').append("Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text());
                                //  $(".alert").css('background-color', '#04b076');
                                //  $(".alert").removeClass("in").show();
                                //  $(".alert").delay(1500).addClass("in").fadeOut(1500);

                                modelAlert("Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text());
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
                        showerrormsg("Please Enter Not Approved Remarks");
                        return;
                    }
                    //  $find('mpnotapprovedrecord').hide();
                    $('#pnlnotapproved').hide()
                    resultStatus = "Not Approved";
                    SaveLabObs();

                }

                function showerrormsg(msg) {
                    //$('#msgField').html('');
                    //$('#msgField').append(msg);
                    //$(".alert").css('background-color', 'red');
                    //$(".alert").removeClass("in").show();
                    //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                    modelAlert(msg);
                }
                var reflextestid = "";
                function checkreflextest() {
                    var aa = 0; var re = "";
                    for (var a = 0; a < LabObservationData.length; a++) {

                        if (LabObservationData[a].Isreflex == "1" && (parseFloat(LabObservationData[a].Value) <= parseFloat(LabObservationData[a].ReflexMin) || parseFloat(LabObservationData[a].Value) >= parseFloat(LabObservationData[a].ReflexMax))) {

                            aa = 1;
                            re = LabObservationData[a].Test_ID + "#" + LabObservationData[a].LabObservation_ID + "#" + LabObservationData[a].LabNo + "#" + LabObservationData[a].Investigation_ID;

                            reflextestid = re;
                            return false;
                        }
                    }

                    if (aa == 0) {

                        reflextestid = "";
                        return true;
                    }
                    else {
                        alert(re);

                        return false;
                    }
                }

                function saveapprovalwithoutreflex() {

                    $find("<%=ModalPopupExtender1.ClientID%>").hide();
                    resultStatus = "Save";
                    SaveLabObs();
                }

                function Approved() {

                    resultStatus = "Approved";
                    SaveLabObs();

                }
                function Preliminary() {
                    resultStatus = "Preliminary Report";
                    SaveLabObs();
                }
                function Save() {
                    resultStatus = "Save";
                    if (IsRadiology && ModalRow != '') {
                        var RcommentValue = CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].getData();
                        LabObservationData[ModalRow].Description = RcommentValue;
                        LabObservationData[ModalRow].Method = "1";
                        SaveLabObs();
                    }
                    else if (checkreflextest() == true) {
                        SaveLabObs();
                    }
                    else {

                        // Show Reflex POP UP
                        $.ajax({
                            url: "MachineResultEntry.aspx/getreflextestlist",
                            //string ApprovedBy,string ApprovalName
                            data: '{Test_ID:"' + reflextestid.split('#')[0] + '",LabObservation_ID:"' + reflextestid.split('#')[1] + '",LabNo:"' + reflextestid.split('#')[2] + '",Investigation_ID:"' + reflextestid.split('#')[3] + '"}',
                            type: "POST", // data has to be Posted    	        
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {
                                $('#mmc tr').slice(1).remove();

                                if (result.d == "") {
                                    SaveLabObs();
                                    return;
                                }


                                for (var a = 0; a <= result.d.split(',').length - 1; a++) {
                                    var mydata = '<tr class="GridViewItemStyle" style="background-color:lemonchiffon">';
                                    mydata += '<td>' + result.d.split(',')[a].split('#')[0] + '</td>';
                                    mydata += '<td><input type="checkbox" checked="checked" id="mmccheck"/></td>';
                                    mydata += '<td id="invid" style="display:none;">' + result.d.split(',')[a].split('#')[1] + '</td>';
                                    mydata += '<td id="testid" style="display:none;">' + result.d.split(',')[a].split('#')[2] + '</td>';
                                    mydata += '<td id="obsidid" style="display:none;">' + result.d.split(',')[a].split('#')[3] + '</td>';
                                    mydata += "</tr>";
                                    $('#mmc').append(mydata);

                                }
                                $find("<%=ModalPopupExtender1.ClientID%>").show();

                            },
                            error: function (xhr, status) {
                            }
                        });
                    }
            }
            function UnHold() {
                resultStatus = "UnHold";
                SaveLabObs();
            }
            function Hold() {
                //resultStatus = "Hold";
                // SaveLabObs(); 
                $('#pnlHoldRemarks').show();
                // $find('mpHoldRemarks').show();
            }
            function SaveLabObs() {
                //   $.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
                var FindingValue="";
                if (IsRadiology && ModalRow != '') {
                    var RcommentValue = CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].getData();
                    LabObservationData[ModalRow].Description = RcommentValue;
                    LabObservationData[ModalRow].Method = "1";
                    FindingValue = $('#txtFinding').val().trim();
                }
                var notapprovalcomment = "";

                    if (resultStatus == "Not Approved")
                        notapprovalcomment = $.trim($("#<%=txtnotappremarks.ClientID%>").val());

                    var HoldRemarks = "";
                    if (resultStatus == "Hold")
                        HoldRemarks = $.trim($("#txtHoldRemarks").val());


                    MachineID_Manual = ($("#<%=ddlTestDon.ClientID%>").val() == "") ? 0 : $("#<%=ddlTestDon.ClientID%>").val();
                    var IsDefaultSing = '<%=IsDefaultSing%>';
                // alert(MachineID_Manual);
                $.ajax({
                    url: "MachineResultEntry.aspx/SaveLabObservationOpdData",
                    //string ApprovedBy,string ApprovalName
                    data: JSON.stringify({ data: LabObservationData, ResultStatus: resultStatus, ApprovedBy: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%>').val() : ''), ApprovalName: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%> :selected').text() : ''), HoldRemarks: HoldRemarks, criticalsave: criticalsave, notapprovalcomment: notapprovalcomment, macvalue: macvalue, MachineID_Manual: MachineID_Manual, FindingValue: FindingValue, MobileApproved: '0', IsDefaultSing: IsDefaultSing, MobileEMINo: "", MobileNo: "", MobileLatitude: "", MobileLongitude: "" }),
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: true,
                        success: function (result) {
                            criticalsave = "0";
                            macvalue = "0";
                            if (result.d == 'success') {
                                modelAlert('Record Saved Successfully', function (response) {
                                    $('#msgField').html('');
                                    // $('#msgField').append('Record Saved Successfully.'); 
                                    //$(".alert").css('background-color', '#04b076');
                                    //$(".alert").removeClass("in").show();
                                    //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                                    var totalRows = PatientData.length - 1;
                                    if (totalRows > currentRow) {
                                        //PickRowData(currentRow + 1);
                                        PickRowData(currentRow);
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
                            else if (result.d == '') {
                                showerrormsg("Please Select Test To Save");
                            }
                            else {

                                if (result.d == "Critical") {
                                    //$('#showpopupmsg').show();
                                    //$('#showpopupmsg').html("Result Has Critical Value.Please Rerun Sample.!<br/>Do You Want To Continue..?");
                                    //$('#popup_box').fadeIn("slow");
                                    //$("#Pbody_box_inventory").css({
                                    //    "opacity": "0.3"
                                    //});
                                    modelAlert("Result Has Critical Value.Please Rerun Sample.!<br/>Do You Want To Continue..?");
                                }
                                if (result.d == "MacValue") {
                                    //$('#showpopupmsg1').show();
                                    //$('#showpopupmsg1').html("Entered Value Different from Mac Reading.!<br/>Do You Want To Continue..?");
                                    //$('#popup_box1').fadeIn("slow");
                                    //$("#Pbody_box_inventory").css({
                                    //    "opacity": "0.3"
                                    //});
                                    modelAlert("Entered Value Different from Mac Reading.!<br/>Do You Want To Continue..?");
                                }
                                else if (result.d == "AbnormalAlert") {
                                    //$('#showpopupmsg').show();
                                    //$('#showpopupmsg').html("Result Has Abnormal Value..!<br/>Do You Want To Continue..?");
                                    //$('#popup_box').fadeIn("slow");
                                    //$("#Pbody_box_inventory").css({
                                    //    "opacity": "0.3"
                                    //});
                                    modelAlert('Result Has Abnormal Value..!<br/>Do You Want To Continue..?');
                                }
                                else {
                                    $('#msgField').html('');
                                    $('#msgField').append(result.d);
                                    $(".alert").css('background-color', 'red');
                                    $(".alert").removeClass("in").show();
                                    $(".alert").delay(1500).addClass("in").fadeOut(1000);
                                    modelAlert(result.d);
                                }
                            }
                            // $.unblockUI();
                        },
                        error: function (xhr, status) {
                            // $.unblockUI();
                            var err = eval("(" + xhr.responseText + ")");

                            if (err.Message == "Critical") {
                                //$('#showpopupmsg').show();
                                //$('#showpopupmsg').html("Result Has Critical Value.Please Rerun Sample.!<br/>Do You Want To Continue..?");
                                //$('#popup_box').fadeIn("slow");
                                //$("#Pbody_box_inventory").css({
                                //    "opacity": "0.3"
                                //});
                                modelAlert('Result Has Critical Value.Please Rerun Sample.!<br/>Do You Want To Continue..?');
                            }
                            else if (err.Message == "MacValue") {
                                //$('#showpopupmsg1').show();
                                //$('#showpopupmsg1').html("Entered Value Diffrent from Mac Reading.!<br/>Do You Want To Continue..?");
                                //$('#popup_box1').fadeIn("slow");
                                //$("#Pbody_box_inventory").css({
                                //    "opacity": "0.3"
                                //});
                                modelAlert("Entered Value Diffrent from Mac Reading.!<br/>Do You Want To Continue..?");
                            }
                            else if (err.Message == "AbnormalAlert") {
                                //$('#showpopupmsg').show();
                                //$('#showpopupmsg').html("Result Has Abnormal Value..!<br/>Do You Want To Continue..?");
                                //$('#popup_box').fadeIn("slow");
                                //$("#Pbody_box_inventory").css({
                                //    "opacity": "0.3"
                                //});
                                modelAlert("Result Has Abnormal Value..!<br/>Do You Want To Continue..?");
                            }
                            else if (err.Message.split('|')[0] == "ManualCritical") {
                                $('#txtObscrNo,#txtMCriticalNewValue,#txtMCriticalOldValue').val('');
                                $('#showpopupmsg3').show();
                                // $('#showpopupmsg3').html("The value of " + err.Message.split('|')[1] + " is critical, Please re run the sample and enter the new value.");
                                modelAlert("The value of " + err.Message.split('|')[1] + " is critical, Please re run the sample and enter the new value.");
                                $('#spnMCriticalObsName').html(err.Message.split('|')[1]);
                                $('#txtMCriticalOldValue').val(err.Message.split('|')[2]);
                                $('#txtObscrNo').val(err.Message.split('|')[5]);
                                //$('#popup_box3').fadeIn("slow");
                                //$("#Pbody_box_inventory").css({
                                //    "opacity": "0.3"
                                //});
                            }
                            else {

                                //$('#msgField').html('');
                                //$('#msgField').append(err.Message);
                                //$(".alert").css('background-color', 'red');
                                //$(".alert").removeClass("in").show();
                                //$(".alert").delay(4000).addClass("in").fadeOut(2000);
                                modelAlert(err.Message);
                            }
                            //alert('Please Contact to ItDose Support Team');
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }

                function unloadPopupBox() {    // TO Unload the Popupbox

                    $('#popup_box').fadeOut("slow");
                    $("#Pbody_box_inventory").css({ // this is just for style        
                        "opacity": "1"
                    });
                    //$('#showpopupmsg').html('');
                }

                function unloadPopupBox1() {    // TO Unload the Popupbox

                    $('#popup_box1').fadeOut("slow");
                    $("#Pbody_box_inventory").css({ // this is just for style        
                        "opacity": "1"
                    });
                    //$('#showpopupmsg').html('');
                }
                function unloadPopupBox3() {    // TO Unload the Popupbox

                    $('#popup_box3').fadeOut("slow");
                    $("#Pbody_box_inventory").css({ // this is just for style        
                        "opacity": "1"
                    });
                    //$('#showpopupmsg').html('');
                }

                function saveifcritical() {
                    criticalsave = "1";
                    unloadPopupBox();
                    SaveLabObs();


                }

                function savediffrentvaluefrommacdata() {
                    macvalue = "1";
                    unloadPopupBox1();
                    SaveLabObs();
                }
                function savedManualCriticalEntry() {
                    if ($('#txtMCriticalNewValue').val().trim() == '') {
                        showerrormsg('Please enter new value');
                        $('#txtMCriticalNewValue').focus();
                        return;
                    }
                    LabObservationData[parseInt($('#txtObscrNo').val()) - 1].Value1 = $('#txtMCriticalOldValue').val();
                    LabObservationData[parseInt($('#txtObscrNo').val()) - 1].Value = $('#txtMCriticalNewValue').val();
                    hot2.render();
                    $('#txtObscrNo,#txtMCriticalNewValue,#txtMCriticalOldValue').val('');
                    unloadPopupBox3();
                }

                function PrintReport(IsPrev) {
                    window.open('printLabReport_pdf.aspx?IsPrev=' + IsPrev + '&TestID=' + PatientData[currentRow].Test_ID + ',&Phead=0');
                }
                function UpdateBarcodes(row, _barcode) {
                    var TestID = PatientData[row].Test_ID;
                    var LedgerTransactionNo = PatientData[row].LedgerTransactionNo;
                    $.ajax({
                        url: "MachineResultEntry.aspx/UpdateLabInvestigationOpdData",
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
                                modelAlert('Vial ID Already  Exit');
                            }

                        },
                        error: function (xhr, status) {
                            // $.unblockUI();

                            modelAlert('Please Contact to ItDose Support Team');
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }

                function closeme() {
                    try {
                        window.opener.SearchData();
                    }
                    catch (e) {
                    }
                    this.close();
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
        });
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                //if ($find('mpHoldRemarks')) {
                //    closeHoldRemarks();
                //}
            }
        }


        function closeHoldRemarks() {
            $("#txtHoldRemarks").val('');
            //  $find('mpHoldRemarks').hide();
            $("#spnHoldRemarks").text('');
            $("#btnHoldRemarks").removeAttr('disabled').val('Save');
        }
        function saveHoldRemarks() {
            if ($.trim($("#txtHoldRemarks").val()) != "") {
                $("#btnHoldRemarks").attr('disabled', 'disabled').val('Submitting...');
                resultStatus = "Hold";
                SaveLabObs();
                // $("#spnHoldRemarks").text('');
            }
            else {
                modelAlert('Please Enter Remarks')
                //$("#spnHoldRemarks").text('Please Enter Remarks');
                $("#txtHoldRemarks").focus();
            }

        }
        function getaddata() {
            var tempData = [];
            $('#mmc tr').each(function () {
                if ($(this).attr("id") != "mmh") {

                    if ($(this).find("#mmccheck").prop('checked') == true) {
                        var itemmaster = [];
                        itemmaster[0] = $(this).find("#testid").html();//testid
                        itemmaster[1] = $(this).find("#obsidid").html();//obsid
                        itemmaster[2] = $(this).find("#invid").html();//booktestid
                        tempData.push(itemmaster);
                    }
                }
            });
            return tempData;
        }
        function Addme() {

            var mydataadj = getaddata();

            if (mydataadj == "") {
                //$('#msgField').html('');
                //$('#msgField').append("Please Select test To Add");
                //$(".alert").css('background-color', 'red');
                //$(".alert").removeClass("in").show();
                //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                modelAlert('Please Select test To Add');
                return;

            }

            $.ajax({
                url: "MachineResultEntry.aspx/saveNewtest",
                data: JSON.stringify({ mydataadj: mydataadj }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 130000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        modelAlert('Record Saved Successfully');
                        //$('#msgField').html('');
                        //$('#msgField').append("Saved Sucessfully");
                        //$(".alert").css('background-color', '#04b076');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        $find("<%=ModalPopupExtender1.ClientID%>").hide();
                    }
                    else {
                        //$('#msgField').html('');
                        //$('#msgField').append(result.d);
                        //$(".alert").css('background-color', 'red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        modelAlert(result.d);
                    }

                },
                error: function (xhr, status) {
                    modelAlert(xhr.responseText);
                }
            });
        }
        $(document).ready(function () {
            $("#<%= txtCommentValueSet.ClientID%>").change(function () {
                setComments($('#<%=txtCommentValueSet.ClientID%>').val());
            });
        });
        function setComments(Test_ID) { // Nirmal 
            hot2.updateSettings({
                cells: function (row, col, prop) {
                    if (LabObservationData[row].LabObservationName == "Comments" && prop === 'Value' && LabObservationData[row].Test_ID == Test_ID) {
                        try {
                            this.type = 'autocomplete';
                            this.source = ['', 'Result Rechecked'];
                        }
                        catch (e) {
                        }
                        LabObservationData[row].Value = 'Result Rechecked';
                    }
                }
            });
        }
        function MainList() {
            $('#divPatient').toggle();
            $('#MainInfoDiv').toggle();

            $('.btnDiv').hide();
            $('#SelectedPatientinfo').hide();
            var PickedRow = 'lnk_' + $('[id$=hdnPickedRow]').val();
            $('#' + PickedRow).closest('tr').find('td').addClass('currentRow');
            $('#' + PickedRow).parent().removeClass('currentRow');
            $('#' + PickedRow).parent().addClass('current highlight');

            //$('html, body').animate({
            //    scrollTop: $("#"+PickedRow).offset().top
            //}, 2000);

            hot1.render();
            hot2.render();
        }

        function ClearRadiologyComment()
        { CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData(''); }
        function TATStatus(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span></span>';//td.innerHTML   
            if (PatientData[row].TATDelay == "1") {
                MyStr = '<span style="color:white;font-weight:bold;font-size:10px;">Outside TAT</span>';
                td.style.background = 'red';
            }
            else if (PatientData[row].TATIntimate == "1") {
                MyStr = '<span style="color:black;font-weight:bold;font-size:10px;">Near TAT</span>';
                td.style.background = 'yellow';
            }
            else {
                MyStr = '<span style="color:white;font-weight:bold;font-size:10px;">Within TAT</span>';
                td.style.background = 'green';
            }
            td.innerHTML = MyStr;
            return td;
        }
    </script>


      <asp:Button ID="Button2" runat="server" style="display:none;" />

      <asp:Panel ID="pnl" runat="server" BackColor="#EAF3FD" style="width:400px;border:2px solid maroon;display:none;">
               <div class="Purchaseheader">Reflex Test</div>
            <br />
          <table id="mmc" style="width:99%;border-collapse:collapse;">
              <tr id="mmh" >
                  <td class="GridViewHeaderStyle">Test Name</td>
                  <td class="GridViewHeaderStyle"></td>
              </tr>
          </table>
                          <table style="width:100%" frame="box">
                              
                              <tr>
                                  <td align="right"><input type="button" value="Add Now" onclick="Addme()" class="savebutton" /> </td><td><asp:Button style="display:none;" ID="btn" runat="server" Text="Close" CssClass="resetbutton" /> <input type="button" class="resetbutton" value="Cancel" onclick="    saveapprovalwithoutreflex()" /></td>
                              </tr>
                              </table>
        </asp:Panel>


    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server"  TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btn">
    </cc1:ModalPopupExtender>

    <div id="ModalPopupExtender2"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 400px;height: 200px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="ModalPopupExtender2" aria-hidden="true">&times;</button>
					<h4 class="modal-title"> Forward Test</h4>
				</div>
				<div class="modal-body">
					 				<div class="row" ">
                                         <div class="col-md-9" >
                                             <b class="pull-left">Select Test  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddltest" runat="server" Width="200px"  CssClass="ddltest  chosen-select"></asp:DropDownList>
                    </div> 
				</div>
			 	  		<div class="row" ">
                                         <div class="col-md-9" >
                                             <b class="pull-left">Select Centre  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddlcentre" runat="server" Width="200px" onchange="binddoctoforward()" CssClass="ddlcentre  chosen-select"></asp:DropDownList>
                    </div> 
				</div>
                    	<div class="row" >
                                         <div class="col-md-9" >
                                             <b class="pull-left">Forward To  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddlforward" runat="server" Width="200px" CssClass="ddltest  chosen-select"></asp:DropDownList>
                    </div> 
				</div>
				</div>
				  <div class="modal-footer" style="text-align:center;"> 
                       <input type="button" value="Forward" onclick="Forwardme()" class="savebutton" />
						 <button type="button"  data-dismiss="ModalPopupExtender2" aria-hidden="true" >Close</button>
				</div>
			</div>
		</div>
	</div>

    <%--<asp:Panel ID="Panel1" runat="server" BackColor="#EAF3FD" style="width:400px;border:2px solid maroon;display:none;">
               <div class="Purchaseheader">Forward Test</div>
            <br />
          <table  style="width:99%;border-collapse:collapse;">
              <tr>
                  <td>&nbsp;Select Test:</td>
                  <td></td>
              </tr>
              <tr>
                   <td>&nbsp;Select Centre:</td>
                     <td></td>
              </tr>
               <tr>
                   <td>&nbsp;Forward To:</td>
                     <td></td>
              </tr>
          </table>
                          <table style="width:100%" frame="box">
                              
                              <tr>
                                  <td align="right"> </td><td><asp:Button ID="Button3" runat="server" Text="Close" CssClass="resetbutton" /></td>
                              </tr>
                              </table>
        </asp:Panel>--%>


     <%--<cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server"  TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1" CancelControlID="Button3">
    </cc1:ModalPopupExtender>--%>

    <div id="Panel2"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 272px;height: 120px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="Panel2" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Delta Check Option</h4>
				</div>
				<div class="modal-body">
					 				<div class="row">
                    <div class="col-md-20"> 
                      <a href="javascript:void(0)" style="font-weight:bold;" onclick="opendelta1()" >Tabular Format</a> 
                    </div> 
				</div>
			 	  	<div class="row">
                    <div class="col-md-20"> 
                      <a href="javascript:void(0)" style="font-weight:bold;"  onclick="opendelta2()" >Graph Format</a>
                    </div> 
				</div>
				</div> 
                <div class="modal-footer"> 
                </div>
			</div>
		</div>
	</div>

     <%--<asp:Panel ID="Panel2" runat="server" BackColor="#EAF3FD" style="width:400px;border:2px solid maroon;display:none;">
               <div class="Purchaseheader">Delta Check Option</div>
            <br />
          <table  style="width:99%;border-collapse:collapse;">
              <tr>
                  <td>&nbsp;&nbsp;&nbsp;  </td>
              </tr>
               <tr>
                  <td>
                      <br />
                  </td>
              </tr>
              <tr>
                  <td>&nbsp;&nbsp;&nbsp; <br/> </td>
              </tr>
               <tr>
                  <td>
                      <br />
                  </td>
              </tr>
              <tr>
                  <td>&nbsp;&nbsp;&nbsp;</td>
              </tr>
              <tr>
                  <td>
                      <br />
                  </td>
              </tr>
              </table>
         </asp:Panel>--%>

 <%--     <cc1:ModalPopupExtender ID="ModalPopupExtender3" runat="server"  TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel2" CancelControlID="Button4">
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
<%--    <asp:Panel ID="pnlHoldRemarks" runat="server" Style="display: none;width:400px; " CssClass="pnlVendorItemsFilter" 
           >
        <div class="Purchaseheader" id="Div2" runat="server">
            <table style="width:100%; border-collapse:collapse" border="0">
                <tr>
                    <td>
                        <b>Hold Remarks</b>
                    </td>
                    <td style="text-align:right">
                        <em ><span style="font-size: 7.5pt"> Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeHoldRemarks()"/>                             
                                to close</span></em>
                    </td>
           </tr>
                </table>          
        </div>         
        <table style="border-collapse:collapse">
             <tr>
                    <td colspan="2" style="text-align:center">
                        <span id="spnHoldRemarks" class="ItDoseLblError"></span>
                        </td>
                </tr>
            <tr>
                <td style="text-align:right">
                    Remarks :&nbsp;
                </td>
                <td>
                   
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center">
                   
                    <asp:Button ID="btnCancelHold" runat="server" CssClass="ItDoseButton" Text="Close"
                                        ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>--%>
     <asp:Button ID="btnHideHold" runat="server" Style="display:none" />
   <%--   <cc1:ModalPopupExtender ID="mpHoldRemarks" runat="server" CancelControlID="btnCancelHold"
                            DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlHoldRemarks"  OnCancelScript="closeHoldRemarks()"  BehaviorID="mpHoldRemarks">
                        </cc1:ModalPopupExtender>  --%>

  <%--  <asp:Panel id="pnlnotapproved" runat="server" style="display:none;width:300px;background-color:lightgray;">
        <div class="Purchaseheader">
           Not Approved Remarks
        </div>

        <center>
            <asp:TextBox ID="txtnotappremarks" runat="server" MaxLength="200" Width="250px" placeholder="Enter Not Approved Remarks" style="text-transform:uppercase;" /><br /><br />
            <input type="button" class="savebutton" onclick="NotApprovedFinaly()" value="Not Approved" />&nbsp;&nbsp;
            <asp:Button ID="btnCancelNotapproved" runat="server" CssClass="resetbutton" Text="Cancel" /><br /><br />
        </center>
    </asp:Panel>


       <cc1:ModalPopupExtender ID="mpnotapprovedrecord" runat="server" CancelControlID="btnCancelNotapproved"
                            DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlnotapproved" BehaviorID="mpnotapprovedrecord">
                        </cc1:ModalPopupExtender> --%>


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
				  <div class="modal-footer" style="text-align:center;"> 
                       <input type="button" class="savebutton" onclick="NotApprovedFinaly()" value="Not Approved" />
				</div>
			</div>
		</div>
	</div>
      

    <div id="popup_box" style="background-color:#eaffc0;height:80px;text-align:center;width:440px;font-weight:bold;display:none">
    <div id="showpopupmsg"></div>
             <br />
             <input type="button" class="savebutton" value=" Yes " onclick="saveifcritical()" />
              <input type="button" class="searchbutton" value=" No " onclick="unloadPopupBox()" />
    </div>

     <div id="popup_box1" style="background-color:#eaffc0;height:80px;text-align:center;width:440px;font-weight:bold;">
    <div id="showpopupmsg1"></div>
             <br />
             <input type="button" class="savebutton" value=" Yes " onclick="savediffrentvaluefrommacdata()" />
              <input type="button" class="searchbutton" value=" No " onclick="unloadPopupBox1()" />
    </div>
      <div id="popup_box3" style="background-color:#eaffc0;height:115px;text-align:center;width:1000px;font-weight:bold;">
    <div id="showpopupmsg3"></div>
         <br />
            <table class="GridViewStyle" cellspacing="0" rules="all" id="tblMCriticalEntry" width="100%"> 
                 <tr>
                     <th class="GridViewHeaderStyle" style="width:50%;"> Observation</th>
                     <th class="GridViewHeaderStyle" style="width:25%;"> New Value</th>
                     <th class="GridViewHeaderStyle" style="width:25%;"> Old Value</th>
                 </tr>
                 <tr>
                     <td class="GridViewLabItemStyle" style="width:50%;" ><span id="spnMCriticalObsName"></span></td>                     
                     <td class="GridViewLabItemStyle" style="width:25%;" ><input type="text" id="txtMCriticalNewValue" style="text-align:center;" /> </td>       
                     <td class="GridViewLabItemStyle" style="width:25%;" ><input type="text" id="txtMCriticalOldValue" style="text-align:center;"  disabled />
                         <input type="text" id="txtObscrNo" style="display:none;" />                         
                     </td>              
                 </tr>
             </table>
             <br />
             <input type="button" class="savebutton" value=" Save "  onclick="savedManualCriticalEntry()"  />
              <input type="button" class="searchbutton" value=" Cancel " onclick="unloadPopupBox3()" />
    </div> 
      <div id="divRerunTest" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 350px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divRerunTest" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Re-Run Test</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Reason</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">
                                <textarea id="txtRemarks" title="Enter Remarks" onlytextnumber="500"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" onclick="$rerunLabTest({reason:$('#txtRemarks').val().trim()})">Save</button>
                        <button type="button" data-dismiss="divRerunTest">Close</button>
                    </div>
                </div>
            </div>
        </div>

    <div id="RejectSample" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width:550px">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeRejectSample()"   aria-hidden="true">&times;</button>
				<h4 class="modal-title">Reject Sample</h4>
                <span id="spnTestID" style="display:none"></span>
			</div>
			<div class="modal-body">
				 <div class="row">
					 <div  class="col-md-8">
						  <label class="pull-left"> Reject Reason    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-15">
						  <input type="text" id="txtRejectReason"  />
					 </div>
                     	 </div>

				<div style="text-align:center" class="row">
					   <button type="button"  onclick="$rejectsample($('#txtRejectReason').val(),$('#spnTestID').text())">Save</button>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
    
    
        <div class="modal fade" id="modelRecollect">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="closeRecollectModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Model</h4>
                        <label id="lblLedgerTransactionRecollect" style="display:none"></label>
                    </div>
                    <div class="modal-body">
                                       <div id="LabOutput" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                    <table id="tblOrderData" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                        <thead>
                            <tr>
                                <td class="GridViewHeaderStyle">SN.</td>
                                <td class="GridViewHeaderStyle">Checkbox</td>
                                <td class="GridViewHeaderStyle">Investigation Name</td> 

                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>

                </div>
                        <div class="row">
                            <div class="col-md-6">
                                Recollect Resion
                            </div>
                            <div class="col-md-18">
                                <textarea id="txtRecollectResion" cols="2" rows="3" class="required"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnRecollectSample" onclick="RecollectSample()" value="Save" style="padding: 2px 5px; border: 1px solid transparent; font-size: 14px;" />
                    </div>
                </div>

            </div>
        </div>


    
    
    <script type="text/javascript">
        function showRejectSample(TestID) {
            $('#spnTestID').text(TestID);
            $('#RejectSample').showModel();
        }
        $closeRejectSample = function () {
            $('#txtRejectReason').val('');
            $('#spnTestID').text('');
            $('#RejectSample').hideModel();
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
                    $closeRejectSample();
                    modelAlert("Sample Rejected Successfully");
                    searchsamples();
                    return;
                }
                else {
                    $closeRejectSample();
                    modelAlert(response);
                    return;
                }
            });
        }
        </script>

    <script type="text/javascript">
        
        var openRecollectModel = function (Ledgertransaction) {
            $("#lblLedgerTransactionRecollect").text(Ledgertransaction);
            GetLabData(Ledgertransaction); 
        }

        var closeRecollectModel = function () {
            $("#txtRecollectResion").val("");
            $("#lblLedgerTransaction").text("");
            
            $("#modelRecollect").hideModel();
            $('#tblOrderData tbody').empty();
        }

        function GetLabData(LedgerTransactionNo) {
            
            serverCall('MachineResultEntry.aspx/GetLabActiveData', { LedgerTransactionNo: LedgerTransactionNo }, function (response) {
                console.log(response)

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    data = GetData.data;
                    $('#tblOrderData tbody').empty();
                    $.each(data, function (i, item) {
                         
                        var rows = "";
                        rows += '<tr>';
                        rows += '<td class="GridViewLabItemStyle" >' + (++i) + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbChkTestId"> <input type="checkbox" id="chkTestId" /> </td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbTestID" style="display:none">' + item.Test_ID + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbID" style="display:none">' + item.ID + '</td>'; 
                        rows += '<td class="GridViewLabItemStyle"  id="tbName">' + item.NAME + '</td>';                         
                        rows += '</tr>';


                        $('#tblOrderData tbody').append(rows);
                    });
                    $("#modelRecollect").showModel(); 
                    $('#tblOrderData').show();

                } else {
                    closeRecollectModel();
                }

                
            });
        }




        function RecollectSample() {
            var itemmaster = "";
            $('#tblOrderData tbody tr input[type=checkbox]:checked').each(function () {

                var TestId = $(this).closest("tr").find("#tbTestID").text();//testid
                if (TestId != "" && TestId != undefined && TestId != null && TestId != '') {
                    if (itemmaster == "") {
                        itemmaster = TestId;
                    } else {
                        itemmaster = itemmaster + ',' + TestId;
                    }

                }
            });
        
            var ResionToRecollect = $("#txtRecollectResion").val();

            if (ResionToRecollect == "" || ResionToRecollect == null || ResionToRecollect == undefined || ResionToRecollect == "\n") {
                modelAlert("Enter Resion To Recollect Sample.");
                return false;
            }

            serverCall('MachineResultEntry.aspx/RecollectData', { TestID: itemmaster, ResionToRecollect: ResionToRecollect }, function (response) {
                var GetData = JSON.parse(response);
                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        closeRecollectModel();
                    })
                }
            });

        }

    </script>


</asp:Content>

