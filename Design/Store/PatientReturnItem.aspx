<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientReturnItem.aspx.cs" Inherits="Design_Store_PatientReturnItem" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Conten1" runat="server">
    <script  type="text/javascript">
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                           ((e.keyCode) ? e.keyCode :
                           ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function SelectRow(text) {
            if ($.trim($(text).val()) != "") {
                $(text).closest("tr").find("input[type='checkbox']").prop("checked", true);
            }
            else {
                $(text).closest("tr").find("input[type='checkbox']").prop("checked", false);
            }
            if ($.trim($(text).val()) == "0") {
                $(text).closest("tr").find("input[type='checkbox']").prop("checked", false);
            }
        }
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            var key;
            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox
            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
        function validateItem() {            
            document.getElementById('<%=btnSearchItem.ClientID%>').disabled = true;
            document.getElementById('<%=btnSearchItem.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSearchItem', '');
        }
        function addItem() {
            document.getElementById('<%=btnAddItem.ClientID%>').disabled = true;
            document.getElementById('<%=btnAddItem.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnAddItem', '');
            
        }
        function validateSave() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
        
        var showIndentModel = function () {
                var divModelMedicineIndentIssue = $('#divModelMedicineIndentIssue');               
                divModelMedicineIndentIssue.showModel();
        }
        var getIndentCount = function (callback) {
            var CRNo = $('#lblTransactionNo').text();
            serverCall('PatientReturnItem.aspx/GetIndentCount', { TID: CRNo }, function (response) {
                $('#spnCounts').text(response);
                //$('#lblTotalSelectedItemsCount').text('Items : ' + rowlength);
                //callback(true);
            });         
        }
        function ConfirmSave() {
            var Ok = confirm('Are you sure want to save the changes?');
            if (Ok)
                return true;
            else
                return false;
        }

    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Patient Return</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" Text="" CssClass="ItDoseLblError"></asp:Label>
            </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Patient
            </div>
            <div class="Content">
               <table style="width:100%;border-collapse:collapse">
                   <tr>
                       <td style="text-align:right;width:20%">
                           Patient Name :&nbsp;
                       </td>
                       <td style="text-align:left;width:20%">
                            <asp:TextBox ID="txtPName" runat="Server" MaxLength="50"></asp:TextBox>
                       </td>
                  
                   <td style="text-align:right;width:20%">
                       IPD No. :&nbsp;
                   </td>
                   <td style="text-align:left;width:20%">
                        <asp:TextBox ID="txtCRNo" runat="server" MaxLength="6" ClientIDMode="Static"></asp:TextBox>
                       <%-- <cc1:FilteredTextBoxExtender ID="ftbIPDNo" runat="server" TargetControlID="txtCRNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>--%>
                   </td>
                       <td style="text-align:left;width:20%">
                             <asp:Button ID="btnSearch" Text="Search" runat="server" OnClick="btnSearch_Click" CausesValidation="False" CssClass="ItDoseButton" />
                       </td>
                        </tr>
               </table>
                   
                      
                   
                
                <br />
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                    CssClass="GridViewStyle" OnPageIndexChanging="GridView1_PageIndexChanging" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        
                        <asp:TemplateField HeaderText="IPD No." >
                                    <ItemTemplate>
                                        <asp:Label ID="lblTransactionID" runat="server" Text='<%# Eval("TransNo").ToString() %>'  />
                                        <asp:Label ID="lblTID" runat="server" Text='<%# Eval("TransactionID") %>'  Visible="false" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="70px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                                </asp:TemplateField>

                        
                        <asp:BoundField DataField="PName" HeaderText="Patient Name">
                            <ItemStyle HorizontalAlign="Left" Width="280px" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Address" HeaderText="Address">
                            <ItemStyle HorizontalAlign="Left" Width="380px" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:CommandField HeaderText="Select" ShowSelectButton="True">
                            <ItemStyle HorizontalAlign="Left" Width="60px" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:CommandField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <asp:Panel ID="pnlPatient" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Patient Information
                </div>
             <div id="divPatientDetail">
                 <div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">

                	<div class="row">
						<div class="col-md-3">
							<label class="pull-left">UHID</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 pull-left">
						 <asp:Label ID="lblPatientID" runat="server"  CssClass="ItDoseLabelSp"></asp:Label>
						</div>
						<div class="col-md-3">
							<label class="pull-left">Patient Name</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:Label ID="lblPatientName" runat="server"  CssClass="ItDoseLabelSp"></asp:Label>
						</div>
						<div class="col-md-3">
							<label>IPD No.</label>
                               <b class="pull-right">:</b>
						</div>

						<div class="col-md-5">
                             <asp:Label ID="lblTID" runat="server"  CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
						</div>
					</div>

                      <div class="row">
						<div class="col-md-3">
							<label class="pull-left">Room No.</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 pull-left">
						<asp:Label ID="lblRoomNo" runat="server"  CssClass="ItDoseLabelSp"></asp:Label>
						</div>
						<div class="col-md-3">
							<label class="pull-left">Doctor Name</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:Label ID="lblDoctorName" runat="server"  CssClass="ItDoseLabelSp"></asp:Label>
						</div>
						<div class="col-md-3">
							<label>Panel</label>
                            <b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                             <asp:Label ID="lblPanelComp" runat="server"  CssClass="ItDoseLabelSp"></asp:Label>
						</div>
					</div>

                 <div class="row">
						<div class="col-md-3">
							<label class="pull-left">Admission Date</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 pull-left">
						<asp:Label ID="lblAdmissionDate" runat="server"  CssClass="ItDoseLabelSp"></asp:Label>
						</div>
						<div class="col-md-3">
                            <asp:TextBox ID="txtIndentNo" runat="server" style="display:none;"></asp:TextBox>
						</div>
						<div class="col-md-5">
						    <asp:Label ID="lblPanelID" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="lblPatient_Type" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="lblCaseTypeID" runat="server" Visible="False" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblReferenceCode" runat="server" Visible="False" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblTransactionNo" runat="server" ClientIDMode="Static" Style=" display:none;" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblRoomID" runat="server" Visible="False" CssClass="ItDoseLabelSp"></asp:Label>
						</div>
						<div class="col-md-3">
							<label></label>
						</div>
						<div class="col-md-5">                                                    
						<button id="btnIndentSearch" onclick="showIndentModel()" type="button" style="box-shadow:none;"><span id="spnCounts" class="badge badge-important">0</span><b style="margin-left: 4px;font-size: 12px">Indents</b> </button>
						</div>
					</div>

                     <div class="row" >
						<div class="col-md-3">
							<label class="pull-left">Item</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 pull-left">
						    <asp:DropDownList ID="ddlItem" runat="server"></asp:DropDownList>
						</div>
						<div class="col-md-16">							
							   <asp:Button ID="btnSearchItem" runat="server" Text="GetItem" OnClick="btnSearchItem_Click" OnClientClick="return validateItem()" CausesValidation="False" CssClass="ItDoseButton"  />
						</div>										
					</div>

                    </div>
                     
                </div>

                </div>


                <table style="width:100%;border-collapse:collapse">
                  
                  
                    <tr>
                        <td style="width:14%;text-align:right">
                            
                        </td>
                        <td colspan="2" style="width:50%">
                            
                        </td>
                        <td style="width:36%;text-align:left">
                             
                        </td>
                    </tr>
                </table>
                
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Issued Items
                </div>
                <div class="Content">
                    <div style="padding-left: 25px; display: none;">
                        <label class="labelForTag">BarCode</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:TextBox ID="txtBar" runat="server" Width="75px" CssClass="ItDoseTextinputText"></asp:TextBox>
                        <div style="display: none;">
                            <asp:Button ID="btnBar" runat="server" Text="BarCode" CssClass="ItDoseButton" OnClick="btnBar_Click" CausesValidation="False" />
                        </div>
                    </div>
                    <br />
                    <asp:GridView ID="grdItems" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%"
                        GridLines="None">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="Server" Checked= '<%# Util.GetBoolean(Eval("IsSelected")) %>'  />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item">
                                <ItemTemplate>
                                    <asp:Label ID="lblItem" Text='<%#Eval("ItemName")%>' runat="server"></asp:Label>
                                    <asp:Label ID="lblType_ID" runat="server" Text='<%# Eval("Type_ID") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Issue Qty.">
                                <ItemTemplate>
                                    <asp:Label ID="lblIssueUnit" Text='<%#Eval("IssueUnits")%>' runat="server"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblDate" Text='<%#Eval("Date")%>' runat="server"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Batch No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblBatch" Text='<%#Eval("BatchNumber")%>' runat="server"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="MRP">
                                <ItemTemplate>
                                    <asp:Label ID="lblMRP" Text='<%#Eval("MRP")%>' runat="server"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="DeptName">
                                <ItemTemplate>
                                    <asp:Label ID="lblDPTName" Text='<%#Eval("DeptName")%>' runat="server"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="InHand">
                                <ItemTemplate>
                                    <asp:Label ID="lblInHandQty" Text='<%#Eval("inHandUnits")%>' runat="server"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Right"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Ret. Qty.">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtRetQty" runat="server" Width="65px" onkeyup="SelectRow(this)" onkeypress="return checkForSecondDecimal(this,event)" Text='<%#Eval("RetQty") %>'    MaxLength="8"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtRetQty" FilterMode="ValidChars" FilterType="Custom,Numbers" ValidChars=".">
                                    </cc1:FilteredTextBoxExtender>
                                    <asp:Label ID="lblLedgerNo" runat="server" Text='<%# Eval("LedgerNumber") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblUnitPric" runat="server" Text='<%# Eval("UnitPrice") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblServiceItemID" runat="server" Text='<%# Eval("ServiceItemID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblExpDate" runat="server" Text='<%# Eval("MedExpiryDate") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategoryID") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblToBeBilled" runat="server" Text='<%# Eval("ToBeBilled") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIsVerified" runat="server" Text='<%# Eval("IsVerified") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIsExpirable" runat="server" Text='<%# Eval("IsExpirable") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblTaxPercent" runat="server" Text='<%# Eval("TaxPercent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblPurTaxPer" runat="server" Text='<%# Eval("PurTaxPer") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIsPackage" runat="server" Text='<%# Eval("IsPackage") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblPackageID" runat="server" Text='<%# Eval("PackageID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblRejectQuantity" runat="server" Text='<%# Eval("RejectQty") %>' Visible="false"></asp:Label>
                                  
								    <asp:Label ID="lblHSNCode" runat="server" Text='<%# Eval("HSNCode") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblIGSTPercent" runat="server" Text='<%# Eval("IGSTPercent") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblSGSTPercent" runat="server" Text='<%# Eval("SGSTPercent") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblCGSTPercent" runat="server" Text='<%# Eval("CGSTPercent") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblGSTType" runat="server" Text='<%# Eval("GSTType") %>'
                                        Visible="false"></asp:Label>
                                    
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                </div>
                <br />
                <div style="clear: both; float: none; padding-left: 25px; text-align: center;">
                    <asp:Button ID="btnAddItem" runat="server" Text="Add Item" OnClick="btnAddItem_Click" OnClientClick="return addItem()" CausesValidation="False" CssClass="ItDoseButton" Visible="False" />
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Return Items
                </div>
                <div>

                    <asp:GridView ID="grdReturnItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdReturnItem_RowCommand" Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item">
                                <ItemTemplate>
                                    <%#Eval("ItemName")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="320px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Batch No.">
                                <ItemTemplate>
                                    <%#Eval("BatchNumber")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="MRP">
                                <ItemTemplate>
                                    <%#Eval("MRP")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Right"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Return Qty.">
                                <ItemTemplate>
                                    <%#Eval("RetQty")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Reject Qty.">
                                <ItemTemplate>
                                    <%#Eval("RejectQty")%>
                                     <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>'  Style="display:none"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Remove" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif" CausesValidation="false" CommandName="imbRemove" CommandArgument='<%# Container.DataItemIndex %>' />

                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </div>
                <br />
                <div style="clear: both; float: none; padding-left: 25px;">
                    <label class="labelForSearch">Issue No.</label>
                    <asp:TextBox ID="txtIndentNumber" runat="server" CssClass="ItDoseTextinputText" Width="225px"></asp:TextBox>

                </div>


                <div style="text-align: center">
                    <asp:CheckBox ID="Chkin" runat="server" Text="Original" Checked="true" Visible="false" />
                    <asp:CheckBox ID="chkPrint" runat="server" Text="Print" Checked="true" />
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton save" OnClick="btnSave_Click"  Text="Save" Visible="False" OnClientClick="return validateSave()" />
                </div>
            </div>
        </asp:Panel>

        
<div id="divModelMedicineIndentIssue"  class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width:90%;max-height:500px;min-height:500px;" >
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divModelMedicineIndentIssue"  aria-hidden="true">&times;</button>
                <h4 class="modal-title">Medicine Prescribed </h4>
            </div>
            <div class="modal-body">
                 <div class="row">
                      <div  class="col-md-3">
                          <label id="lblIndentSearch" class="pull-left">  Indent  No  </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-5">
                         <asp:TextBox ID="txtIndentID" runat="server"></asp:TextBox>
                     </div>
                     <div  class="col-md-3">

                    <asp:Button ID="btnView"  runat="server" OnClick="btnView_Click1" Text="View" TabIndex="7" CssClass="save pull-left" ClientIDMode="Static" ToolTip="Click To View" />
                         <%-- <label class="pull-left">  From Date    </label>
                          <b class="pull-right">:</b>--%>
                     </div>
                     <div  class="col-md-5 hidden">
                           <asp:TextBox ID="txtFDSearch" runat="server" ClientIDMode="Static"   ToolTip="Select Indent From" ></asp:TextBox>
                           <cc1:calendarextender ID="Calendarextender1" TargetControlID="txtFDSearch" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                     <div  class="col-md-3">
                         <%--  <label class="pull-left"> To Date    </label>
                           <b class="pull-right">:</b>--%>
                     </div>
                     <div  class="col-md-5 hidden">
                          <asp:TextBox ID="txtTDSearch" runat="server" ClientIDMode="Static"   ToolTip="Select Indent To" ></asp:TextBox>
                          <cc1:calendarextender ID="Calendarextender2" TargetControlID="txtTDSearch" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                 </div>


                
                   <div class="Content hidden">
                 <div class="row" style="text-align: center;">
                        <div  style="text-align: center;">
                            <div id="colorindication" runat="server">
                                <table style=" width:100%">
                                    <tr>                                
                                        <td style="height: 22px">&nbsp;<asp:Button ID="btnSN" runat="server" Width="20px" Height="20px" BackColor="LightBlue"
                                            BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnSN_Click"
                                            ToolTip="Click for Open Requisition" Style="cursor: pointer;" />
                                        </td>
                                        <td style="text-align: left; height: 22px;">Pending</td>
                                        <td style="height: 22px">
                                            <asp:Button ID="btnRN" runat="server" Width="20px" Height="20px" BackColor="green"
                                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnRN_Click"
                                                ToolTip="Click for Close Requisition" Style="cursor: pointer;" />
                                        </td>
                                        <td style="text-align: left; height: 22px;">Return</td>
                                        <td style="height: 22px">&nbsp;<asp:Button ID="btnNA" runat="server" Width="20px" Height="20px" BackColor="LightPink"
                                            BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnNA_Click"
                                            ToolTip="Click for Reject Requisition" Style="cursor: pointer;" />
                                        </td>
                                        <td style="text-align: left; height: 22px;">Reject</td>
                                        <td style="height: 22px">&nbsp;<asp:Button ID="btnA" runat="server" Width="20px" Height="20px" BackColor="Yellow"
                                            BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnA_Click"
                                            ToolTip="Click for Partial Requisition" Style="cursor: pointer;" />
                                        </td>
                                        <td style="text-align: left; height: 22px; width: 145px;">&nbsp;Partial</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                   </div>
                       </div>

          <div class="indentDetails hidden"  >
            <div class="Purchaseheader" >
                Indent Detail</div>
            <asp:Button ID="butadd" runat="server" Text="Add this" CssClass="ItDoseButton" Style="display: none;" />
                   <div class="Content">
                <div class="row" style="overflow: auto;">
                    <asp:GridView ID="grisearch" runat="server" OnSelectedIndexChanged="grisearch_SelectedIndexChanged" OnRowDataBound="gvGRN_RowDataBound" OnRowCommand="gvGRN_RowCommand"  Width="100%"
                        AutoGenerateColumns="False" CssClass="GridViewStyle">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                           <%-- <asp:CommandField ShowSelectButton="True" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                         <asp:TemplateField HeaderText="View" HeaderStyle-Width="20px">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                        ImageUrl="~/Images/view.gif"
                                        CommandArgument='<%# Eval("IndentNo")+"#"+Eval("DeptFrom")+"#"+Eval("TransactionID")+"#"+Eval("DeptFrom")+"#"+Eval("UserName")+"#"+Eval("StatusNew")  %>'
                                        Visible='<%#Util.GetBoolean(Eval("VIEW")) %>' />
                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status")%>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="20px">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgReject" runat="server" CausesValidation="false" CommandName="AReject"
                                        ImageUrl="~/Images/delete.gif"
                                        CommandArgument='<%# Eval("IndentNo")+"#"+Eval("DeptFrom")+"#"+Eval("TransactionID")+"#"+Eval("DeptFrom")+"#"+Eval("UserName")+"#"+Eval("StatusNew")  %>'
                                        Visible='<%#Util.GetBoolean(Eval("VIEW")) %>' OnClientClick="return ConfirmSave()" />
                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("Status")%>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="IPD No.">
                                <ItemTemplate>
                                    <%# Eval("IPDNo") %>
                                    <asp:Label ID="lblTransactionID" runat="server" Visible="false" Text='<%# Eval("TransactionID")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="UHID">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("PatientID")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Patient Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblPName" runat="server" Text='<%# Eval("PName")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Requisition Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentDate" runat="server" Text='<%# Eval("dtEntry")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Requisition No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="135px" />
                            </asp:TemplateField>                               

                            <asp:TemplateField HeaderText="From Department">
                                <ItemTemplate>
                                    <asp:Label ID="lblFromDepartment" runat="server" Text='<%# Eval("DeptFrom")%>'></asp:Label>
                                    <%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="User">
                                <ItemTemplate>
                                    <asp:Label ID="lblFromUser" runat="server" Text='<%# Eval("UserName")%>'></asp:Label>
                                    <%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Requisition Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentType" runat="server" Text='<%# Eval("IndentType")%>'></asp:Label>
                                          <asp:Label ID="lblStatusNew" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                            </asp:TemplateField>


                           <%-- <asp:TemplateField HeaderText="Contact No." ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemTemplate>
                           
                                    <asp:Label ID="lblPatientId" runat="server" Text='<%# Eval("PatientID") %>' Visible="False"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                        </Columns>
                    </asp:GridView>
                </div>
                       </div>



        </div>


<div class="Content">
                <div  class="row">
                    <div id="divIndentDetails" style="max-height:370px;overflow:auto;min-height:370px;" class="col-md-24" runat="server">
                       <asp:Panel ID="pnlSearch" runat="server">
               <%-- <div class="Purchaseheader">
                    Search Results
                </div>--%>
             <table style="width: 100%;display:none" >
                    <tr>
                        <td style="width: 15%; text-align: right;">Patient Name :
                        </td>
                        <td style="width: 20%; text-align: left">
                            <asp:Label ID="lblPName" runat="server" CssClass="ItDoseLabel"></asp:Label>
                        </td>
                        <td style="width: 10%; text-align: right;">IPD No. :
                        </td>
                        <td style="width: 15%; text-align: left">
                            <asp:Label ID="lblTransactionID" runat="server" Style="display:none;" CssClass="ItDoseLabel"></asp:Label>
                            <asp:Label ID="lblTransNo" runat="server"  CssClass="ItDoseLabel"></asp:Label>
                        </td>
                        <td style="width: 10%; text-align: right">Panel :
                        </td>
                        <td style="width: 30%; text-align: left">
                            <asp:Label ID="lblPanelName" runat="server" Width="166px" CssClass="ItDoseLabel"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 15%; text-align: right;">Age/Gender :
                        </td>
                        <td style="width: 20%; text-align: left">
                            <asp:Label ID="lblAge" runat="server" CssClass="ItDoseLabel"></asp:Label>
                        </td>
                        <td style="width: 10%; text-align: right">UHID :
                        </td>
                        <td style="width: 15%; text-align: left">
                            <asp:Label ID="lblRegistrationNo" runat="server" CssClass="ItDoseLabel"></asp:Label>
                        </td>
                        <td style="width: 10%; text-align: right;">Doctor :
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <asp:Label ID="lblDocName" runat="server" CssClass="ItDoseLabel"></asp:Label>
                        </td>
                    </tr>
               
                </table>
            <div class="row"  >
               <asp:Repeater ID="grdIndentDetails"  OnItemDataBound="grdIndentDetails_ItemDataBound" runat="server">


                    <HeaderTemplate>

                        <table class="GridViewStyle" cellspacing="0" style="border-collapse: collapse;width:100%">
                            <tr style="text-align: center; background-color: #afeeee;">
                                <th class="GridViewHeaderStyle" scope="col">Indent No.</th>
                                <th class="GridViewHeaderStyle" style="width:284px" scope="col">Item Name</th>
                                <th class="GridViewHeaderStyle" scope="col">Requested Qty.</th>
                                <th class="GridViewHeaderStyle" scope="col">Return Qty.</th>
                                <th class="GridViewHeaderStyle" scope="col">Rejected Qty.</th>
                                <th class="GridViewHeaderStyle" scope="col" style="display:none;">Dept. Available Qty.</th>
                                <th class="GridViewHeaderStyle" scope="col">Store Available Qty.</th>
                                <th class="GridViewHeaderStyle" scope="col">Pending Qty.</th>
                                <th class="GridViewHeaderStyle" scope="col">Narration</th>
                                <th class="GridViewHeaderStyle" scope="col">Return Qty.</th>
                                <th class="GridViewHeaderStyle" scope="col">Reject Qty.</th>
                                


                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr id="Tr1" runat="server">
                            <td class="GridViewItemStyle">
                               <%-- <asp:CheckBox ID="chkSelect" runat="server" />--%>
                                <asp:Label ID="lblIndentID" runat="server" Text='<%# Eval("id") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo") %>' ></asp:Label></td>
                            <td class="GridViewItemStyle" style="text-align: left;">
                                <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
                            </td>
                            <td class="GridViewItemStyle" style="text-align:center">
                                <asp:Label ID="lblRequestedQty" runat="server" Text='<%# Eval("ReqQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle" style="text-align:center">
                                <asp:Label ID="lblIssuedQty" runat="server" Text='<%# Eval("ReceiveQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle" style="text-align:center">
                                <asp:Label ID="lblRejectedQty" runat="server" Text='<%# Eval("RejectQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle" style="text-align:center;display:none;">
                                <asp:Label ID="lblDeptAvailQty" runat="server" Text='<%# Eval("DeptAvailQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle" style="text-align:center">
                                <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle" style="text-align:center">
                                <asp:Label ID="lblPendingQty" CssClass="lblPendingQuantity" runat="server" Text='<%# Eval("PendingQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="Label1" runat="server" ForeColor="Brown" Text='<%# Eval("Narration") %>'></asp:Label>
                            </td>
                             <td class="GridViewItemStyle" style="width:95px">
                                <asp:TextBox runat="server" id="txtReturnQuantity"  CssClass="ItDoseTextinputNum txtReturnQuantity" onkeyup="onRejectReturnQuantityChange(this)" onlynumber="10"></asp:TextBox>
                            </td>
                             <td class="GridViewItemStyle" style="width:95px">
                                 <asp:TextBox runat="server" id="txtRejectQuantity" CssClass="ItDoseTextinputNum txtRejectQuantity" onkeyup="onRejectReturnQuantityChange(this)" onlynumber="10"  ></asp:TextBox>
                            </td>
 

                        </tr>

                      
                    </ItemTemplate>
                    <FooterTemplate >
                          <%--<asp:Button  ID="btnsubmit" runat="server"  Text="Select Indent" TabIndex="7" OnClick="btnSubmit_Click"
                CssClass="ItDoseButton" ClientIDMode="Static" ToolTip="Click To Submit Indent" />--%>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>


                </div>




            </asp:Panel>

                    </div>
                </div>

    <div class="row">
                           <div class="col-md-8"></div>
                           <div class="col-md-8"></div>
                           <div class="col-md-8"> 
                              <asp:Button ID="btnAdditemsToReturn" Text="Add" CssClass="save pull-right" Visible="false" runat="server" OnClick="btnSubmit_Click"/> 
                           </div>
                       </div>
    </div>


                <div style="display:none"  class="row divIndentItemsDetails">
                    <div style="padding-right:2px"  class="col-md-24">
                        <div class="col-md-3">
                            <label class="pull-left"><b></b></label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                           
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left"><b></b></label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left"><b>Barcode</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" class="ItDoseTextinputNum" id="txtScanMedicine" onkeyup="onScanBarcode(event)" />
                        </div>
                    </div>
                </div>


                <div  style="display:none"  class="row divIndentItemsDetails">
                    <div id="divIndentItemsDetails" style="max-height:250px; min-height:250px;overflow:auto" class="col-md-24">


                    </div>
                </div>
             <%--   </fieldset>--%>

            </div>
            <div style="display:none" class="modal-footer divIndentItemsDetails">
                 <button type="button" onclick="addIndentItems()">Add</button>
                <button type="button"  data-dismiss="divModelMedicineIndentIssue">Close</button>
            </div>
        </div>
    </div>
</div>

    </div>



<script type="text/javascript">



    //onkeyup


    var onRejectReturnQuantityChange = function (el) {

        var selectedRow = $(el).closest('tr');

        var rejectQuantity = Number(selectedRow.find('.txtRejectQuantity').val());
        var returnQuantity = Number(selectedRow.find('.txtReturnQuantity').val());
        var pendingQuantity = Number(selectedRow.find('.lblPendingQuantity').text());

        if (pendingQuantity < (rejectQuantity + returnQuantity))
        {
            modelAlert('Invalid Quantity.', function () {
                el.value = 0;
            });
        }

    }


</script>

</asp:Content>