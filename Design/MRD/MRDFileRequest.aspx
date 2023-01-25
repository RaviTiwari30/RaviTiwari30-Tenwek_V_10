<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MRDFileRequest.aspx.cs" Inherits="Design_MRD_MRDFileRequest" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 
   
    
    <script type="text/javascript" >

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
        });
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();

            });

        });



        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
        function patientTypeID(el) {
            var pType = el;
            if (pType == 'OPD' || pType == 'ALL') {
                $('#txtTransactionNo').attr('disabled', 'disabled');
                $('#txtTransactionNo').val('');
            }
            else {

                $('#lblPatientType').text(el + ' No');
                $('#txtTransactionNo').removeAttr('disabled');
                $('#txtTransactionNo').val('');
            }
        }
</script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>File Requisition</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />&nbsp;
           
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Patient Type
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlPatientType" runat="server" ClientIDMode="Static" onchange="patientTypeID(this.value)" ></asp:DropDownList>
                    </div>
                    <div class="col-md-3">

                        <label class="pull-left">
                            UHID No
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtPatientID" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" ToolTip="Enter MR No." TabIndex="1"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Patient Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                             <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static" TabIndex="2" ToolTip="Enter Patient Name" ></asp:TextBox>
                    </div>
                        </div> 
                    <div class="row">
                     <div class="col-md-3">
                        <label class="pull-left" id="lblPatientType">
                           IPD No
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                               <asp:TextBox ID="txtTransactionNo" runat="server" ClientIDMode="Static" MaxLength="11" 
                                TabIndex="8"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbTran" runat="server" FilterType="Numbers,Custom" ValidChars="/" TargetControlID="txtTransactionNo">
                            </cc1:FilteredTextBoxExtender>
                    </div>
                      <div class="col-md-3">
                        <label class="pull-left">
                           Doctor
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                                <asp:DropDownList ID="cmbDoctor" ClientIDMode="Static" runat="server"  TabIndex="9" ToolTip="Select Doctor" CssClass="cmbDoctor  chosen-select chosen-container">
                            </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                    <label class="pull-left">Panel</label>
                      <b class="pull-right">:</b>
                      </div>
                     <div class="col-md-5">
                               <asp:DropDownList ID="cmbCompany" runat="server"  TabIndex="10" ToolTip="Select Panel" ClientIDMode="Static" CssClass="cmbCompany  chosen-select chosen-container">
                            </asp:DropDownList>
                        </div>
                     
                </div>
                    <div class="row">
                 
                     <div class="col-md-3">
                            <label class="pull-left">MRD File</label>
                            <b class="pull-right">:</b>
                        </div>
                     <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbIssueReturn" runat="server" RepeatDirection="Horizontal">
                             <asp:ListItem Value="0" Selected="True">Request</asp:ListItem>
                             <asp:ListItem Value="1">Return</asp:ListItem>
                         </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                             <label class="pull-left">
                                 <asp:CheckBox ID="chkIgnore" ClientIDMode="Static" runat="server" Text="Ignore" />
                                 F Date
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">

                             <asp:TextBox ID="MRDReceivedfromdate" runat="server" TabIndex="14" ClientIDMode="Static" ToolTip="Click To Select From Date">
                             </asp:TextBox>
                             <cc1:CalendarExtender ID="CalendarExtender3" TargetControlID="MRDReceivedfromdate" Format="dd-MMM-yyyy"
                                 Animated="true" runat="server">
                             </cc1:CalendarExtender>
                         </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 To Date
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:TextBox ID="MRDReceivedTodate" runat="server" TabIndex="15" ClientIDMode="Static" ToolTip="Click To Select To Date"></asp:TextBox>
                             <cc1:CalendarExtender ID="CalendarExtender4" TargetControlID="MRDReceivedTodate" Format="dd-MMM-yyyy"
                                 Animated="true" runat="server">
                             </cc1:CalendarExtender>
                         </div>
                    </div>
                    <div class="row" style="display:none">
                             <div class="col-md-3">
                            <label class="pull-left">Parent Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                     <div class="col-md-5">
                             <asp:DropDownList ID="ddlParentPanel" runat="server"  TabIndex="11"
                                ToolTip="Select Parent Panel" ClientIDMode="Static" CssClass="ddlParentPanel  chosen-select chosen-container" >
                            </asp:DropDownList>

                        </div>
                        </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">Room Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                 <asp:DropDownList ID="cmbRoom" ClientIDMode="Static" runat="server"  TabIndex="7" ToolTip="Select Room Type">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Discharge Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                 <asp:DropDownList ID="ddlDischageType" ClientIDMode="Static" runat="server" TabIndex="13"
                                ToolTip="Select Discharge Type"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">Discharge Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                <asp:TextBox ID="txtDischageDate" runat="server" TabIndex="14" ClientIDMode="Static"   ToolTip="Click To Select From Date"></asp:TextBox>
                              <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtDischageDate"  Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                              <asp:TextBox ID="ucFromDate" runat="server" TabIndex="14" ClientIDMode="Static"  Visible="false" ToolTip="Click To Select From Date"
                                Width="170px" ></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate"  Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                           <div class="col-md-3">
                            <label class="pull-left">Admitted Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                  <asp:TextBox ID="txtAdmittedDate" runat="server" TabIndex="15"  ClientIDMode="Static" ToolTip="Click To Select To Date"
                                Width="170px" ></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtAdmittedDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="ucToDate" runat="server" TabIndex="15" Visible="false" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                Width="170px" ></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                           </div>
                </div>
                
                <div class="col-md-1"></div>
            </div>
            
            
      
        </div>
         <div class="POuter_Box_Inventory">
             <div class="row">
                     <div style="text-align: center;" class="col-md-24">
                     
                     <input type="button" id="btnSearch"  value="Search" class="ItDoseButton" onclick="SearchData()"/>
                 </div>
             </div>
             
         </div>
         <div class="POuter_Box_Inventory">
              <div class="Purchaseheader">
                Search Result&nbsp;</div>
             <div id="divSearchResult">

             </div>
         
         </div>
         </div>
    <div id="divFilerequest" class="modal fade " style="display:none">
         <div class="modal-dialog">
             <div class="modal-content" style="background-color: white; width: 723px; height: 230px">
                  <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divFilerequest" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">File Request  <label id="lblopupMsg" class="ItDoseLblError"></label></h4>
                    </div>
                  <div class="modal-body">
                            <div class="row">
                            <div class="col-md-1"> </div>
                            <div class="col-md-22">
                                <div class="row">
                                <div class="col-md-8">
                                    <label class="pull-left">Document Type</label>
                                    <b class="pull-right">:</b>
                                </div>
                                    <div class="col-md-12">
                                        <span id="spnfileID" style="display:none"></span>
                                        <span id="spnIPDNo" style="display:none"></span>
                                         <span id="spnMrdNo" style="display:none"></span>
                                        <input type="checkbox" id="chkSoftCopy" name="copy" onclick="checkconditionsoft()" /> &nbsp;&nbsp;Soft Copy
                                        <input type="checkbox" id="chkHardCopy" name="copy" onclick="checkconditionhard()" />&nbsp;&nbsp;Hard Copy
                                    </div>

                                    </div>
                                <div class="row">
                                    <div class="col-md-8">
                                        <label class="pull-left">Average Return Time</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-12">
                                        <asp:DropDownList ID="ddldays" runat="server" Width="100px" ClientIDMode="Static" CssClass="requiredField">
                                        </asp:DropDownList>&nbsp;Days
                                        <asp:DropDownList ID="ddlHours" runat="server" Width="100px" ClientIDMode="Static">
                                        </asp:DropDownList>Hours
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-8">
                                        <label class="pull-left">Remarks</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-12">
                                        <textarea id="txtArea" rows="2" cols="30" class="txt-box requiredField" style="height:56px;width:298px"></textarea>
                                    </div>

                                </div>
                                </div>
                                <div class="col-md-1"></div>
                 </div>
             </div>
                  <div class="modal-footer">
                      <div class="row" style="text-align:center">
                     <div class="col-md-24" style="text-align:center">
                         <input type="button" class="ItDoseButton" id="btnSendRequest" onclick="SaveRequest()" value="Save" />
                         <asp:Button ID="btnMClose" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Close" OnClientClick="ClosePopup()" />
                          </div>
                      </div>
                      
                      </div>

        </div>
             </div>
        </div>
     <div id="divFilereturn" class="modal fade " style="display:none">
         <div class="modal-dialog">
             <div class="modal-content" style="background-color: white; width: 723px; height: 194px">
                  <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divFilereturn" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">File Return <label id="Label2" class="ItDoseLblError"></label>
                     <span id="Span1" style="display:none"></span>
                    <span id="Span2" style="display:none"></span>
                    <span id="Span3" style="display:none"></span>
                        </h4>
                    </div>
                   <div class="modal-body">
                       <div class="row">
                        <div class="col-md-1"></div>
                           <div class="col-md-22">
                               <div class="row">
                                   <div class="col-md-5">
                                       <label class="pull-left">DocumentType</label>
                                       <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                       <input type="checkbox" id="chkReturnHardCopy" name="copy" onclick="checkconditionhard()" checked="checked" />Hard Copy
                                   </div>
                                     <div class="col-md-7">
                                   <label class="pull-left">Average Return Time</label>
                                   <b class="pull-right">:</b></div>
                                  <div class="col-md-2">
                                   <span id="spnReturnDays"></span>&nbsp;Days &nbsp;
                               </div>
                                   <div class="col-md-2">
                                       <span id="spnReturnHours"></span>&nbsp;Hours&nbsp;
                                   </div>
                               </div>
                               
                               <div class="row">
                                   <div class="col-md-5">
                                       <label class="pull-left">Remarks</label>
                                       <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-12">
                                    <textarea id="txtReturnRemarks" rows="2" cols="30" class="txt-box " ></textarea>
                                   </div>

                               </div>
                               
                           </div>

                           <div class="col-md-1"></div>
                       </div>
                       </div>
                 <div class="modal-footer">
                      <div class="row" style="text-align:center">
                     <div class="col-md-24" style="text-align:center">
                       <input type="button" class="ItDoseButton" id="btnsaveReturn" onclick="SaveReturn()" value="SAVE" />
                        <asp:Button ID="btnCancelReturn" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="CLOSE" OnClientClick="ClosePopup()" />
                         </div>
                          </div>
                 </div>
                 </div>
             </div>
           </div>


    <cc1:ModalPopupExtender ID="mpeReturn" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancelReturn" PopupControlID="PanelReturn" ClientIDMode="Static"
       TargetControlID="btnCancelReturn"  X="425" Y="150" BehaviorID="mpeReturn">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="PanelReturn" runat="server" CssClass="pnlItemsFilter" Style="
        width: 500px; height: 205px;display:none" ClientIDMode="Static">
        <div class="Purchaseheader" style="width:490px;"> File Return&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <em ><span style="font-size: 7.5pt">Press
            esc or click <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="ClosePopup()" /> to close</span></em></div>
          
             
        <div>
            <table>
              
                 <tr>
                    <td colspan="3" style="text-align:center;">
                      
                 
                    </td>
                </tr>
            </table>
           
               <div class="sub-btns">
                                  
               </div>     
            </div>
                        
        
        
      
    </asp:Panel>

    <script  id="sptPatientSearch" type="text/html">
        <table id="tbl_PatientSearch" cellpadding="5" cellspacing="0" class="GridViewStyle" style="width:1291px">
            <thead>
                <tr>
                    <th class="GridViewHeaderStyle">Select</th>
                    <th class="GridViewHeaderStyle">S.No.</th>
                    <th class="GridViewHeaderStyle">PType	</th>
                    <th class="GridViewHeaderStyle">IPD No.	</th>
                      <th class="GridViewHeaderStyle">UHID No.</th>
                    <th class="GridViewHeaderStyle">Name</th>
                    <th class="GridViewHeaderStyle">Age/Sex	</th>
                   <%-- <th class="GridViewHeaderStyle">Discharge Type</th>--%>
                    <th class="GridViewHeaderStyle">Doctor Name</th>
                     <th class="GridViewHeaderStyle">Panel</th>
                     <th class="GridViewHeaderStyle" style="display:none">File Id</th>
                    <th class="GridViewHeaderStyle">Admitted Date</th>
                    <th class="GridViewHeaderStyle">Discharge Date</th>
                   <th class="GridViewHeaderStyle">MRD File Receive Date</th>
                    <th class="GridViewHeaderStyle" style="display:none">ReutrnDay</th>
                    <th class="GridViewHeaderStyle" style="display:none">ReturnHours</th>
                </tr>
            </thead>
            <tbody>
                <# 
                var DataLength=SearchResultData.length;
                window.status="Total Records Found :"+ DataLength;
                var dataObjRow;
                for( var i=0;i<DataLength;i++)
                    {
                    dataObjRow=SearchResultData[i];
                #>

                <tr>
                    <td class="GridViewItemStyle">
                     
                        <# if($("[id*=rdbIssueReturn] input:checked").val()=='1')
                        {#>
                         <img src="../../Images/Post.gif" alt="Request" onclick="ShowReturnPopUp(this)" />
                        <#}
                        
                        else
                        {#>
                        <img src="../../Images/Post.gif" alt="Request" onclick="ShowPopUp(this)" />
                        <#}#>


                    </td>
                    <td class="GridViewItemStyle"><#=i+1#></td>
                    <td class="GridViewItemStyle" id="td1"><#=dataObjRow.type#>	</td>
                    <td class="GridViewItemStyle" id="td25"><#=dataObjRow.TransNo#>	</td>
                      <td class="GridViewItemStyle" id="tdPatientId"><#=dataObjRow.Patient_ID#></td>
                    <td class="GridViewItemStyle"><#=dataObjRow.NAME#></td>
                    <td class="GridViewItemStyle"><#=dataObjRow.AgeSex#></td>
                                      
                   <%-- <td class="GridViewItemStyle"><#=dataObjRow.DischargeType#></td>--%>
                   <td class="GridViewItemStyle"><#=dataObjRow.Doctor#></td>
                   <td class="GridViewItemStyle"><#=dataObjRow.Company_Name#></td>
                   <td class="GridViewItemStyle" id="tdFileID" style="display:none"><#=dataObjRow.FileID#></td>
                   <td class="GridViewItemStyle"><#=dataObjRow.AdmissionDateTime#></td>
                   <td class="GridViewItemStyle"><#=dataObjRow.DischargeDateTime#></td>
                   <td class="GridViewItemStyle"><#=dataObjRow.FileEntryDateTime#></td>
                   <td class="GridViewItemStyle" id="tdHardCopyIssue" style="display:none" ><#=dataObjRow.HardCopyIssue#></td>
                   <td class="GridViewItemStyle" id="tdSoftCopy" style="display:none" ><#=dataObjRow.IsIssued#></td>
                   <td class="GridViewItemStyle" id="tdIsUploaded" style="display:none" ><#=dataObjRow.UploadStatus#></td>
                   <td class="GridViewItemStyle" id="tdReturnDay" style="display:none" ><#=dataObjRow.ReturnDay#></td>
                   <td class="GridViewItemStyle" id="tdReturnHours" style="display:none" ><#=dataObjRow.ReturnHours#></td>
                     <td class="GridViewItemStyle" id="tdtransactionId" style="display:none"><#=dataObjRow.Transaction_ID#>	</td>
                </tr>
                   
 <#}#>
            </tbody>
        </table>
    </script>
    <script type="text/javascript">
        function SaveRequest() {
            if (Validation()) {
                $("#btnSendRequest").val('Saving....').attr("disabled", "disabled");

                var soft = 0; hard = 0;
                if ($('#chkSoftCopy').is(':checked')) {
                    soft = 1;
                }
                if ($('#chkHardCopy').is(':checked')) {
                    hard = 1;
                }
                $.ajax({
                    url: 'Services/FileSentToMRD.asmx/SaveMRDRequisition',
                    type: 'POST',
                    data: JSON.stringify({ MRNo: $('#spnMrdNo').text(), IPDNO: $('#spnIPDNo').text(), MRDFileID: $('#spnfileID').text(), HardCopy: hard, SoftCopy: soft, ReturnDays: $('#ddldays').val(), ReturnHours: $('#ddlHours').val(), Remarks: $('#txtArea').val()}),
                    dataType: 'JSON',
                    contentType: 'application/json; charset=utf-8',
                    async: false,
                    success: function (responce) {
                        SearchResultData = jQuery.parseJSON(responce.d);
                        if (SearchResultData == "1") {
                            modelAlert('Request Have been sent successfully.', function () { 
                            $("#btnSendRequest").val('Save').removeAttr("disabled");
                            Clear();
                            $('#divFilerequest').hide();
                            });
                        }
                        else {
                            modelAlert('Request have not been sent.Please try again');
                            $("#btnSendRequest").val('Save').removeAttr("disabled");
                            // $('#<%=lblMsg.ClientID %>').text('Record Not found');
                        }

                    }
                });
            }
        }

        function SaveReturn() {
            if (ValidationReturn()) {
                $("#btnsaveReturn").val('Saving....').attr("disabled", "disabled");
                var  hard = 0;
                if ($('#chkReturnHardCopy').is(':checked')) {
                    hard = 1;
                }
                $.ajax({
                    url: 'Services/FileSentToMRD.asmx/SaveMRDReturnFile',
                    type: 'POST',
                    data: JSON.stringify({ MRNo: $('#spnMrdNo').text(), IPDNO: $('#spnIPDNo').text(), MRDFileID: $('#spnfileID').text(), HardCopy: hard, ReturnDays: $('#spnReturnDays').text(), ReturnHours: $('#spnReturnHours').text(), Remarks: $('#txtReturnRemarks').val() }),
                    dataType: 'JSON',
                    contentType: 'application/json; charset=utf-8',
                    async: false,
                    success: function (responce) {
                        SearchResultData = jQuery.parseJSON(responce.d);
                        if (SearchResultData == "1") {
                            modelAlert('Return Have been sent successfully.');
                            $("#btnsaveReturn").val('Save').removeAttr("disabled");
                            Clear();
                            $('#divFilereturn').hide();
                        }
                        else {
                            modelAlert('Return have not been sent.Please try again');
                            $("#btnsaveReturn").val('Save').removeAttr("disabled");
                        }

                    }
                });
            }
        }


        function Validation() {

            var HardCopy = $('#chkHardCopy').is(':checked');
            var SoftCopy = $('#chkSoftCopy').is(':checked');

            if (SoftCopy == false && HardCopy == false) {
                modelAlert('Please Select The File Copy Type');
                return false;
            }
            if ($('#txtArea').val() == "") {
                modelAlert("Please Enter The Remarks");
                return false;
            }
            if ($('#<%=ddldays.ClientID%>').val() == "Select") {
                modelAlert("Please Select The Return Days");
                return false;
            }
            if ($('#<%=ddlHours.ClientID%>').val() == "Select") {
                modelAlert("Please Select The Return Hours");
                  return false;
            }
            if ($('#txtArea').val() == "") {
                modelAlert("Please Enter The Remarks");
                return false;
            }
              return true;
        }

        function ValidationReturn() {
            var HardCopy = $('#chkReturnHardCopy').is(':checked');

            if ($('#txtReturnRemarks').val() == "") {
                modelAlert("Please Enter The Remarks");
                return false;
            }
            return true;
        }
        function SearchData() {
            var objSearch = new Object();
            objSearch.PatientId = $('#txtPatientID').val();
            objSearch.PatientName = $('#txtName').val();
            
            objSearch.DischargeType = $('#ddlDischageType').val();
            
            objSearch.DoctorId = $('#cmbDoctor').val();
            objSearch.TransactionId = $('#txtTransactionNo').val();
            objSearch.parentPanelId = $('#ddlParentPanel').val();
            objSearch.PanelId = $('#cmbCompany').val();
            objSearch.FromDate = $('#MRDReceivedfromdate').val();
            objSearch.Todate = $('#MRDReceivedTodate').val();
            objSearch.FileType = $("[id*=rdbIssueReturn] input:checked").val();
            objSearch.pType = $('#ddlPatientType').val();
            var ISingnore = 0;
            if ($('#chkIgnore').is(':checked')) {
                ISingnore = 1;
            }
            $.ajax({
                url: 'Services/FileSentToMRD.asmx/MRDRequisitionSearch',
                type: 'POST',
                data: JSON.stringify({ SearchData: objSearch, AdmittedDate: $('#txtAdmittedDate').val(), DischargeDate: $('#txtDischageDate').val(), IsIgnore: ISingnore }),
                dataType: 'JSON',
                contentType: 'application/json; charset=utf-8',
                async: false,
                success: function (responce) {
                    SearchResultData = jQuery.parseJSON(responce.d);
                    if (SearchResultData != null) {
                        if (SearchResultData.length > 0) {
                            var OutPut = $("#sptPatientSearch").parseTemplate(SearchResultData);
                            $('#divSearchResult').html(OutPut);
                            $('#divSearchResult').show();
                            $('#<%=lblMsg.ClientID %>').text('');
                            
                        } else {
                            $('#divSearchResult').html('');
                            $('#divSearchResult').hide();
                            modelAlert('Patient Record Not Found');
                        }
                    }
                    else {
                        $('#divSearchResult').html('');
                        $('#divSearchResult').hide();
                        modelAlert('Patient Record Not Found');
                    }

                }
            });
        }
        function Clear() {
            $('#spnMrdNo,#spnIPDNo,#spnfileID').text('');
        }
        function ShowPopUp(rowid) {
            Clear();
            VaidateMRDFileRequest($(rowid).closest('tr').find('#tdtransactionId').text(),function (status) {
                if (status) {
                    $('#spnMrdNo').text($(rowid).closest('tr').find('#tdPatientId').text());
                    $('#spnIPDNo').text($(rowid).closest('tr').find('#tdtransactionId').text());
                    $('#spnfileID').text($(rowid).closest('tr').find('#tdFileID').text());
                    if ($(rowid).closest('tr').find('#tdIsUploaded').text() == "0") {
                        $('#chkSoftCopy').removeAttr('checked');
                        $('#chkSoftCopy').attr('disabled', 'disabled');
                        modelAlert('Document Not Uploaded');
                        $('#lblopupMsg').text('document not uploaded');
                    }
                    else {
                        $('#chkSoftCopy').removeAttr('disabled');
                        $('#lblopupMsg').text('');
                    }
                    if ($(rowid).closest('tr').find('#tdSoftCopy').text() == "1")
                        $('#chkSoftCopy').attr('checked', 'checked');
                    else
                        $('#chkSoftCopy').attr('checked', false);
                    if ($(rowid).closest('tr').find('#tdHardCopyIssue').text() == "1")
                        $('#chkHardCopy').attr('disabled', 'disabled');
                    else
                        $('#chkHardCopy').attr('checked', false);
                    $('#divFilerequest').showModel();
                }
                else {
                    modelAlert('Request Already generated from your department against the Selected IPD No.');
                }
            });
            }


        var VaidateMRDFileRequest = function (ipdNo, callback) {
            serverCall('Services/FileSentToMRD.asmx/VaidateMRDFileRequest', { IPDNO: ipdNo }, function (response) {
                if (Number(response) == 0) {
                    callback(true);
                }
                else {
                    callback(false);
                }
            });
        
        }

        function  ShowReturnPopUp(rowid) {
            Clear();
            if ($(rowid).closest('tr').find('#tdHardCopyIssue').text() == 1) {
                $('#spnMrdNo').text($(rowid).closest('tr').find('#tdPatientId').text());
                $('#spnIPDNo').text($(rowid).closest('tr').find('#tdtransactionId').text());
                $('#spnfileID').text($(rowid).closest('tr').find('#tdFileID').text());
                $('#chkReturnHardCopy').attr('checked', 'checked');
                $('#chkReturnHardCopy').attr('disabled', 'disabled');
               $('#divFilereturn').showModel();
                $('#spnReturnDays').text($(rowid).closest('tr').find('#tdReturnDay').text());
                $('#spnReturnHours').text($(rowid).closest('tr').find('#tdReturnHours').text());
            }
            else {
                alert('No Hardcopy in your account.Only Hardcopy will return');
            }
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpe2")) {
                    $find("mpe2").hide();
                }
            }
        }
        function ClosePopup() {
            $('#divFilerequest').hide();
            $('#divFilereturn').hide();
        }
        function checkconditionsoft() {
            if ($('#chkSoftCopy').is(':checked')) {
                $('#chkHardCopy').attr('checked', false);
                $('#chkSoftCopy').attr('checked', true);
            }
        }
        function checkconditionhard() {
            if ($('#chkHardCopy').is(':checked')) {
                $('#chkHardCopy,#chkReturnHardCopy').attr('checked', true);
             
                $('#chkSoftCopy').attr('checked', false);
            }
        }
    </script>

</asp:Content>

