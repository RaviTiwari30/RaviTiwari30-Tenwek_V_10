<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PastHistory.aspx.cs" Inherits="Design_CPOE_PastHistory" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
        <link rel="Stylesheet" href="../../Styles/PurchaseStyle.css" />
     <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
   <%-- <script type="text/javascript" src="../../Scripts/CheckUnSaveData.js"></script>--%>
    <script type="text/javascript">
        function validate() {
            if (($.trim($("#txtIllnesses").val()) == "") && ($.trim($("#txtSurgeries").val()) == "") && ($.trim($("#txtAllergies").val()) == "") && ($.trim($("#txtMedications").val()) == "")) {
                $("#lblMsg").text('Please Enter Illnesses OR Surgeries/Hospitalizations OR Allergies OR Medications');
                $("#txtIllnesses").focus();
                return false;
            }
        }
        function Check(textBox, maxLength) {
            if (textBox.value.length > maxLength) {
                $("#<%=lblMsg.ClientID%>").text("You cannot enter more than " + maxLength + " characters.");
                textBox.value = textBox.value.substr(0, maxLength);
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
           <div id="Pbody_box_inventory">
           
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Allergies</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Allergies
                </div>
                <table style="width: 100%">
                    <tr style="display:none">
                        <td style="text-align:right; vertical-align:top">
                             Illnesses :&nbsp;
                            </td>
                        <td>
                            <asp:TextBox ID="txtIllnesses" onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);" ClientIDMode="Static" runat="server" TextMode="MultiLine" Width="480px" Height="80px"></asp:TextBox>
                            
                            </td>
                        </tr>
                     <tr style="display:none">
                        <td style="text-align:right; vertical-align:top">
                            Surgeries/Hospitalizations :&nbsp;
                            </td>
                        <td>
                            <asp:TextBox ID="txtSurgeries" onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);" runat="server" ClientIDMode="Static" TextMode="MultiLine" Width="480px" Height="80px"></asp:TextBox>
                           
                            </td>
                        </tr>
                     <tr>
                        <td style="text-align:right; vertical-align:top">
                            Allergies :&nbsp;
                            </td>
                        <td>
                            <asp:TextBox ID="txtAllergies" runat="server" ClientIDMode="Static" TextMode="MultiLine" onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);" Width="480px" Height="80px"></asp:TextBox>
                              
                            </td>
                        </tr>
                     <tr style="display:none">
                        <td style="text-align:right; vertical-align:top">
                            Medications :&nbsp;
                            </td>
                        <td>
                            <asp:TextBox ID="txtMedications" runat="server" ClientIDMode="Static" TextMode="MultiLine" Width="480px" Height="80px" onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);"></asp:TextBox>
                            <b>Entry By:</b> <asp:Label ID="lblEntryBy" runat="server" ForeColor="Green"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
             <div class="POuter_Box_Inventory" style="text-align:center">
                 <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click"  OnClientClick="return validate()"/>
                 </div>
               <div class="POuter_Box_Inventory" style="text-align:center">
             <div class="Purchaseheader">Result
            </div>
              <asp:GridView  ID="grid" runat="server" CssClass="GridViewStyle" 
                        AutoGenerateColumns="false" >
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Center" >
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="Date" HeaderText="Date" HeaderStyle-Width="200px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Center" />
                            <asp:TemplateField HeaderText="Allergies" HeaderStyle-Width="700px" ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Center" 
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                   <asp:Label ID="lblpro" runat="server" Text='<%# Util.GetString( Eval("Allergies")) %>' Visible="true"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <%-- <asp:TemplateField HeaderText="Previous Medications" HeaderStyle-Width="700px" ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Center" 
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                   <asp:Label ID="lblpreMedication" runat="server" Text='<%# Util.GetString( Eval("Medications")) %>' Visible="true"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                         <%--  <asp:BoundField DataField="ProgressNote" HeaderText="Progress Note" HeaderStyle-Width="700px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                                <asp:BoundField DataField="Name" HeaderText="Entry By" HeaderStyle-Width="200px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Center"  />
                                  <asp:TemplateField HeaderText="Edit" Visible="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        </Columns>
                    </asp:GridView></div>
            </div>
 </form>
</body>
</html>
