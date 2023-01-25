<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cpoe_CarePlan.aspx.cs" Inherits="Design_CPOE_Cpoe_CarePlan" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title> </title>
     <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CheckUnSaveData.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        function validate() {
            if ($.trim($("#txtFamilyHistory").val()) == "") {
                $("#lblMsg").text('Please Enter Care Plan');
                $("#txtFamilyHistory").focus();
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
            <div class="POuter_Box_Inventory" style="text-align: center;">

              <b>  Doctor Progress Note</b><br />
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Doctor Care Plan
                </div>
                <table style="width: 100%">
                    <tr>
                        
                        <td>
                            <asp:TextBox ID="txtFamilyHistory" CssClass="requiredField" onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);" ClientIDMode="Static" runat="server" TextMode="MultiLine" Width="560px" Height="80px"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" OnClientClick="return validate()" />
                <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" OnClick="btnCancel_Click" Visible="false"/>
                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Result
            </div>
              <asp:GridView  ID="grid" runat="server" CssClass="GridViewStyle" 
                        AutoGenerateColumns="false" OnRowCommand="grid_RowCommand" OnRowDataBound="grid_RowDataBound">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="Date" HeaderText="Date" HeaderStyle-Width="100px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:TemplateField HeaderText="Notes" HeaderStyle-Width="700px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                   <asp:Label ID="lblpro" runat="server" Text='<%# Util.GetString( Eval("CarePlan")) %>' Visible="true"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                         <%--  <asp:BoundField DataField="ProgressNote" HeaderText="Progress Note" HeaderStyle-Width="700px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                                <asp:BoundField DataField="Name" HeaderText="Entry By" HeaderStyle-Width="200px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                  <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblUserID" Text='<%#Eval("EntryBy") %>' runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
