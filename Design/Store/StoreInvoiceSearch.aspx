<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StoreInvoiceSearch.aspx.cs" Inherits="Design_Store_StoreInvoiceSearch" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    
<head runat="server">
   <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Store Invoice Search</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
          <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Issue - Return Detail</div>
            <div style="text-align: center">
                <table  style="width: 100%">
                    <tr>
                        <td style="text-align: center; height: 18px; width: 986px;" colspan="4">
                            <asp:Label ID="lblIssue" runat="server" Font-Size="XX-Small" BackColor="#99FFCC" ForeColor="Black"></asp:Label>
                            &nbsp;<asp:Label ID="lblReturn" Font-Size="XX-Small" runat="server" BackColor="#FF99CC" ForeColor="White"></asp:Label>
                            &nbsp;<asp:Label ID="lblBilledIssue" Font-Size="XX-Small" runat="server" BackColor="#FF8000" ForeColor="White"></asp:Label>
                            &nbsp;<asp:Label ID="lblNotBilledIssue" Font-Size="XX-Small" runat="server" BackColor="#804000" ForeColor="White"></asp:Label>
                            &nbsp;<asp:Label ID="lblNotBilledReturn" Font-Size="XX-Small" runat="server" BackColor="#C0C0FF" ForeColor="Black"></asp:Label>
                            &nbsp;<asp:Label ID="lblBilledReturn" Font-Size="XX-Small" runat="server" BackColor="Fuchsia" ForeColor="White"></asp:Label>
                            </td>
                    </tr>
                    <tr  style="display:none">
                        <td style="text-align:center; width: 986px;" class="ItDoseLabel" colspan="4">
                         <asp:DropDownList ID="ddlPackage" runat="server" Visible="false" >
                        <asp:ListItem Text="All" Selected="True" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Package" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Non Package" Value="3"></asp:ListItem>
                        </asp:DropDownList>
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:DropDownList ID="ddlStts" runat="server" Visible="false" AutoPostBack="true" OnSelectedIndexChanged="ddlStts_SelectedIndexChanged">
                        <asp:ListItem Text="All" Selected="True" Value="All"></asp:ListItem>
                        <asp:ListItem Text="Issue" Value="Issue"></asp:ListItem>
                        <asp:ListItem Text="Return" Value="Return"></asp:ListItem>
                        </asp:DropDownList>
                        
                             <uc1:EntryDate ID="ucDateFrom" runat="server" Visible="false"/>
                             <uc1:EntryDate ID="ucDateTo" runat="server" Visible="false"/>   
                            </td>
                    </tr>
                    <tr  style="display:none">
                        <td class="ItDoseLabel" colspan="4" style="text-align: center; width: 986px;">
                    
                    <asp:TextBox ID="txtBillNo" Visible="false" CssClass="ItDoseTextinputText" runat="server" Width="180px"></asp:TextBox>
                            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                            &nbsp;
                            <asp:TextBox ID="txtTID" Visible="false" runat="server" CssClass="ItDoseTextinputText" Width="134px"></asp:TextBox>
                             <asp:CheckBox ID="Chkin" runat="server" Text="Original" Checked="true" Visible="false" /></td>
                    </tr>
                    <tr>
                    <td style="text-align:center; width: 986px;" class="ItDoseLabel" colspan="4">
                        &nbsp;
                        <asp:Button ID="btnSearch" CssClass="ItDoseButton" Visible="false" runat="server" OnClick="btnSearch_Click" Text="Search" />
                        <asp:Button ID="btnPDF" CssClass="ItDoseButton" runat="server" OnClick="btnPDF_Click" Text="Print" />
                        <asp:Button ID="btnBillRegister" Visible="false" CssClass="ItDoseButton" runat="server" OnClick="btnBillRegister_Click" Text="Bill Register" /></td>
                    </tr>
                  
                    <tr>
                        <td colspan="4" style="width: 986px">
                <asp:GridView ID="grdSearch" runat="server" OnRowDataBound="grdSearch_RowDataBound" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="grdSearch_RowCommand"  >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                        </asp:TemplateField>                                                                       
                        <asp:TemplateField HeaderText="Print">
                                 <HeaderTemplate>
                            <input type="checkbox" id="chkbxslctal" runat="server" title="Select"/>
                          </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkbx" Visible='<%# Util.getbooleanTrueFalse(Eval("BillNo"))  %>' runat="server" />
                            <asp:Label ID="lblTypeOfTnxHDN" Visible="false" Text='<%#Eval("TypeOfTnx") %>' runat="server"></asp:Label>                                
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                        </asp:TemplateField> 
                         <asp:BoundField DataField="Date" HeaderText="Date">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:BoundField>
                          <asp:BoundField DataField="IndentNo" HeaderText="IndentNo">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:BoundField>
                         <asp:BoundField DataField="ItemName" HeaderText="ItemName">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="175px" />
                        </asp:BoundField>
                         <asp:BoundField DataField="BatchNumber" HeaderText="Batch">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:BoundField>                        
                         <asp:BoundField DataField="MRP" HeaderText="MRP">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:BoundField>                        
                         <asp:BoundField DataField="SoldUnits" HeaderText="Qty">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:BoundField>
                         <asp:BoundField DataField="Amount" HeaderText="Amount">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="BillAmount" HeaderText="BillAmt">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="BillStatus" HeaderText="Billing">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:BoundField>
                          <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                              <asp:Label ID="lbltype" Text='<%#Eval("TypeOfTnx") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                        </asp:TemplateField>  
                         <%--<asp:BoundField DataField="TypeOfTnx" HeaderText="Type">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:BoundField>--%>
                         <asp:BoundField DataField="Dept" HeaderText="Dept">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:BoundField>
                          <asp:TemplateField HeaderText="Billno">
                            <ItemTemplate>
                              <asp:Label ID="lblbillnoHDN" Text='<%#Eval("BillNo") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                        </asp:TemplateField>    
                        <%-- <asp:BoundField DataField="BillNo" HeaderText="BillNo">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:BoundField>--%>
                       
                        <asp:TemplateField HeaderText="Indent">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" runat="server" Visible='<%# Util.getbooleanTrueFalse(Eval("IndentNo"))  %>' CausesValidation="false" CommandName="AView"
                                    ImageUrl="../Purchase/Image/view.gif" CommandArgument='<%# Eval("IndentNo") %>' />                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Invoice">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbInvoiceView" runat="server" Visible='<%# Util.GetBoolean(Eval("IsInvoice"))  %>' CausesValidation="false" CommandName="IView"
                                    ImageUrl="../Purchase/Image/view.gif" CommandArgument='<%# Eval("BillNo")+"#"+ Eval("TypeOfTnx") +"#"+Eval("TransactionID") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        
                       <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                              <asp:Label ID="lblTID" Text='<%#Eval("TransactionID") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                        </asp:TemplateField>                         
                    </Columns>
                </asp:GridView>
                        </td>
                    </tr>
                </table>
                &nbsp;&nbsp;</div>
        </div>
    </div>
    

<script type="text/javascript">
    var objoldval = "";
    function calpopup() {
        var gv = document.getElementById('<%=grdSearch.ClientID %>');
     var grdlngth = gv.rows.length;
     for (var j = 1; j <= grdlngth - 1; j++) {
         var obj = ((gv.rows[j].cells[1]).firstChild);
         if (obj != null) {
             if (obj.checked == true) {
                 var obj1 = ((gv.rows[j].cells[13]).firstChild);
                 var obj1val = obj1.innerHTML;
                 var typeoftnx = ((gv.rows[j].cells[11]).firstChild);
                 var typeoftnxval = typeoftnx.innerHTML;

                 var TID = ((gv.rows[j].cells[16]).firstChild);

                 if (objoldval == obj1val) {

                 }
                 else {
                     objoldval = obj1.innerHTML;

                     window.open('InternalStockTransferPatientRecipt.aspx?bilno=' + obj1val + '&typeOftnx=' + typeoftnxval + '&TID=' + TID.innerHTML);
                 }

             }
         }
     }
 }


 function chkall() {
     var gv = document.getElementById('<%=grdSearch.ClientID %>');
    var grdlngth = gv.rows.length;
    for (var j = 1; j <= grdlngth - 1; j++) {
        var obj = ((gv.rows[j].cells[1]).firstChild);
        if (obj != null) {
            if (obj.checked == true) {
                ((gv.rows[j].cells[1]).firstChild.checked) = false;
            }
            else {
                ((gv.rows[j].cells[1]).firstChild.checked) = true;
            }
        }
    }
}

$(document).ready(function () {
    $("#grdSearch_ctl01_chkbxslctal").click(function () {
        $(":checkbox").attr('checked', this.checked);


    });
});
 </script>
    </form>
</body>
</html>
