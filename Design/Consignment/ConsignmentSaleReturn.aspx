<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ConsignmentSaleReturn.aspx.cs" Inherits="Design_Consignment_ConsignmentSaleReturn" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
   
    <script type="text/javascript">
        $(document).ready(function () {
           // modelAlert("Medicine Returned Successfully");
        });
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
        function AlertMsg(LedgerTransactionNo, LedTnxNo) {
            //alert(LedgerTransactionNo);
            modelAlert("Medicine Returned Successfully");
            if (typeof (LedgerTransactionNo) != "undefined") {
                window.open('../Common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&IsBill=1&Duplicate=0&Type=PHY');
                window.open('../Store/VendorReturnReport.aspx?NRGP=' + LedTnxNo + '');
            }
            location.href = 'ConsignmentSaleReturn.aspx';
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Consignment Sales Return</b>
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
                    CssClass="GridViewStyle" Width="100%" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemTemplate>
                                <asp:Label ID="lblTransactionID" runat="server" Text='<%# Eval("TransNo").ToString() %>' />
                                <asp:Label ID="lblTID" runat="server" Text='<%# Eval("TransactionID") %>' Visible="false" />
                            </ItemTemplate>
                            <HeaderStyle Width="70px" CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
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
                                    <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Patient Name</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label>IPD No.</label>
                                    <b class="pull-right">:</b>
                                </div>

                                <div class="col-md-5">
                                    <asp:Label ID="lblTID" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Room No.</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5 pull-left">
                                    <asp:Label ID="lblRoomNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Doctor Name</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblDoctorName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label>Panel</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblPanelComp" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Admission Date</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5 pull-left">
                                    <asp:Label ID="lblAdmissionDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtIndentNo" runat="server" Style="display: none;"></asp:TextBox>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblPanelID" runat="server" Visible="False"></asp:Label>
                                    <asp:Label ID="lblPatient_Type" runat="server" Visible="False"></asp:Label>
                                    <asp:Label ID="lblCaseTypeID" runat="server" Visible="False" CssClass="ItDoseLabelSp"></asp:Label>
                                    <asp:Label ID="lblReferenceCode" runat="server" Visible="False" CssClass="ItDoseLabelSp"></asp:Label>
                                    <asp:Label ID="lblTransactionNo" runat="server" ClientIDMode="Static" Style="display: none;" CssClass="ItDoseLabelSp"></asp:Label>
                                    <asp:Label ID="lblRoomID" runat="server" Visible="False" CssClass="ItDoseLabelSp"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label></label>
                                </div>
                                <div class="col-md-5">
                                    <%--<button id="btnIndentSearch" onclick="showIndentModel()" type="button" style="box-shadow: none;"><span id="spnCounts" class="badge badge-important">0</span><b style="margin-left: 4px; font-size: 12px">Indents</b> </button>--%>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Item</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5 pull-left">
                                    <asp:DropDownList ID="ddlItem" runat="server"></asp:DropDownList>
                                </div>
                                <div class="col-md-16">
                                    <asp:Button ID="btnSearchItem" runat="server" Text="GetItem" OnClick="btnSearchItem_Click" OnClientClick="return validateItem()" CausesValidation="False" CssClass="ItDoseButton" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Issued Items
                </div>
                <div class="Content">
                    <asp:GridView ID="grdItems" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%" GridLines="None">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="Server" Checked='<%# Util.GetBoolean(Eval("IsSelected")) %>' />
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
                                    <asp:Label ID="lblVenLedgerNo" runat="server" Text='<%#Eval("VenLedgerNo") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblSaleTaxPer" runat="server" Text='<%#Eval("SaleTaxPer") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblLedgerTransactionNo" runat="server" Text='<%#Eval("LedgerTransactionNo") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblChalanNo" runat="server" Text='<%#Eval("ChalanNo") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblInvoiceNo" runat="server" Text='<%#Eval("InvoiceNo") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblInvoiceDate" runat="server" Text='<%#Eval("InvoiceDate") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCurrencyFactor" runat="server" Text='<%#Eval("CurrencyFactor") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblConversionFactor" runat="server" Text='<%#Eval("ConversionFactor") %>' Visible="false"></asp:Label>

                                    <asp:Label ID="lblDiscPer" runat="server" Text='<%#Eval("DiscPer") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblDiscAmt" runat="server" Text='<%#Eval("DiscAmt") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblMajorUnit" runat="server" Text='<%#Eval("MajorUnit") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIsFree" runat="server" Text='<%#Eval("IsFree") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblDeptLedgerNo" runat="server" Text='<%#Eval("DeptLedgerNo") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblSpecialDiscPer" runat="server" Text='<%#Eval("SpecialDiscPer") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblisDeal" runat="server" Text='<%#Eval("isDeal") %>' Visible="false"></asp:Label>

                                    <asp:Label ID="lblOtherCharges" runat="server" Text='<%#Eval("OtherCharges") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblMarkUpPercent" runat="server" Text='<%#Eval("MarkUpPercent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCurrencyCountryID" runat="server" Text='<%#Eval("CurrencyCountryID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCurrency" runat="server" Text='<%#Eval("Currency") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblRate" runat="server" Text='<%#Eval("Rate") %>' Visible="false"></asp:Label>

                                    <asp:Label ID="lblIGSTAmt" runat="server" Text='<%#Eval("IGSTAmt") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblSGSTAmt" runat="server" Text='<%#Eval("SGSTAmt") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCGSTAmt" runat="server" Text='<%#Eval("CGSTAmt") %>' Visible="false"></asp:Label>

                                    <asp:Label ID="lblConsignmentID" runat="server" Text='<%#Eval("ConsignmentID") %>' Visible="false"></asp:Label>
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
                <div style="text-align: center">
                    <asp:CheckBox ID="Chkin" runat="server" Text="Original" Checked="true" Visible="false" />
                    <asp:CheckBox ID="chkPrint" runat="server" Text="Print" Checked="true" />
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton save" OnClick="btnSave_Click"  Text="Save" Visible="False" OnClientClick="return validateSave()" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

