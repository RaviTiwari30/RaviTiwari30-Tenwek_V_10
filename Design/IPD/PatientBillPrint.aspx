<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientBillPrint.aspx.cs" Inherits="Design_IPD_PatientBillPrint" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bill Print</title>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
</head>
<body>
        <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <script type="text/javascript">
        $(document).ready(function () {
            if ($('#lblBillNo').text() == "") {
                $("#ddlbillcurrency option[value=0]").remove();
            }
            if ($('#lblIsPackage').text() == "0") {
                $("#ddlBillType option[value='PKGSUM']").remove();
                $("#ddlBillType option[value='PKGDET']").remove();
            }
            if ($('#lblissurgery').text() == "0") {
                $("#ddlBillType option[value='SUR']").remove();
                $("#ddlBillType option[value='SURSUM']").remove();
            }
        });
        function PendingInvestigation()
        {
            modelAlert("Some Investigation Is Pending Till Now. Kindly Cross Verify To Respective Department.");
        }
    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Patient Bill Print</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Patient Bill Print
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Type of Bills</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlBillType">
                            <option value="SUM">Summary Bill Display Name Wise</option>
                            <option value="DET">Detail Bill </option>
                           <%-- <option value="DETMIXCONFIG">Detail Bill Config Wise</option>
                            <option value="DETMIXDISP">Detail Bill Display Name Wise</option>
                            <option value="DETITEM">Detail Bill Item Wise</option>--%>
                            <option value="PKGSUM">Package Bill Summary</option>
                            <option value="PKGDET">Package Bill Detail</option>
                            <option value="SURSUM">Surgery Bill Summary</option>
                            <option value="SUR">Surgery Bill Detail</option>
                            <option value="DBG" style="display:none">Detail Bill With</option>
                            <option value="BOF" style="display:none">Insurance Bill</option>
                            </select>
                    </div>
                    <div class="col-md-4"><label class="pull-left">Bill Print Currency</label>
                        <b class="pull-right">:</b></div>
                    <div class="col-md-4">
                        <select id="ddlbillcurrency">
                            <option value="1">Base Currency</option>
                            <option value="0">Bill Generate Currency</option>
                        </select>
                    </div>
                    <div class="col-md-6"><asp:CheckBox ID="chkSuppressReceipt" ClientIDMode="Static" runat="server" CssClass="ItDoseCheckbox" Font-Bold="true" Text="Show Receipt/Refund in Bill" Checked="True"  /></div>
                     <div class="col-md-2">
                        <input type="button" value="Bill Print" class="ItDoseButton" onclick="PrintBill()" id="btnbillprint" />
                         <asp:Label ID="lblissurgery" runat="server" ClientIDMode="Static" style="display:none" Text="0"></asp:Label>
                         <asp:Label ID="lblIsPackage" runat="server" ClientIDMode="Static" style="display:none" Text="0"></asp:Label>
                         <asp:Label ID="lblBillNo" runat="server" ClientIDMode="Static" style="display:none" Text=""></asp:Label>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Investigation Status
                </div>
                <table style="width: 100%; border-collapse: collapse">  
                    <tr>
                        <td>
                            <asp:GridView ID="grdInvestigations" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="S/No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <HeaderStyle Width="25px" HorizontalAlign="Center" />
                                        <ItemStyle Width="25px" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Department" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="40px">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDept" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Department") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Investigations" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblInvestigation" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="200px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Date" HeaderText="Date" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemStyle Width="100px" HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="40px" ItemStyle-HorizontalAlign="Center"
                                        HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lblApprove" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Approved") %>'> </asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Width="150px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        var PrintBill = function () {
            if (($('#ddlBillType').val() == "PKGSUM" || $('#ddlBillType').val() == "PKGDET") && $('#lblIsPackage').text() == "0") {
                modelAlert("This patient is not having the package bill.");
                return;
            }
            if (($('#ddlBillType').val() == "SUR" || $('#ddlBillType').val() == "SURSUM") && $('#lblissurgery').text() == "0") {
                modelAlert("This patient is not having the surgery bill.");
                return;
            }
            if ($('#ddlbillcurrency').val() == "0" && $('#lblBillNo').text() == "") {
                modelAlert("Without bill generate system can not print the bill on bill generated currency.");
                return;
            }
            var isreceipt = 0;
            if ($('#chkSuppressReceipt').is(':checked')) {
                isreceipt = 1;
            }
            var TransactionID = '<%=Request.QueryString["TransactionID"].ToString()%>';
            window.open('IPD_BillPrint.aspx?TransactionID=' + TransactionID + '&Duplicate=0&BillType=' + $('#ddlBillType').val() + '&IsBaseCurrency=' + $('#ddlbillcurrency').val() + '&IsReceipt=' + isreceipt);
        }
    </script>
</body>
</html>
