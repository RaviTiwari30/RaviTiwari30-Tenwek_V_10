<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PharmacyConsultNotes.aspx.cs" Inherits="Design_IPD_PharmacyConsultNotes" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title></title>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/Message.js" type="text/javascript"></script>

    <script type="text/javascript">
        if ($.browser.msie) {
            $(document).on("keydown", function (e) {
                var doPrevent;
                if (e.keyCode == 8) {
                    var d = e.srcElement || e.target;
                    if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                        doPrevent = d.readOnly
                            || d.disabled;
                    }
                    else
                        doPrevent = true;
                }
                else
                    doPrevent = false;
                if (doPrevent) {
                    e.preventDefault();
                }
            });
        }
    </script>
    <style type="text/css">
        .auto-style1 {
            width: 189px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
       <script type="text/javascript">
           $(document).ready(function () {

           });

           function note(e, type) {
               e.preventDefault();

               if ($.trim($("#<%=txtPrescription.ClientID%>").val()) == "") {
                   $("#<%=lblMsg.ClientID%>").text('Please Enter Incidence Book');
                    $("#<%=txtPrescription.ClientID%>").focus();
                    return false;
                }
                if (type == 'Save') {
                    document.getElementById('<%=Btnsave.ClientID%>').disabled = true;
                   $('#<%=Btnsave.ClientID%>').val('Submitting...');
                   __doPostBack('Btnsave', '');
               }
               else {
                   document.getElementById('<%=btnUpdate .ClientID%>').disabled = true;
                   document.getElementById('<%=btnUpdate.ClientID%>').value = 'Submitting...';
                   $('#<%=btnUpdate.ClientID%>').val('Submitting...');
                   __doPostBack('btnUpdate', '');
               }

           }
        </script>
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Pharmacy Consult Notes </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Pharmacy Consult Notes
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right" class="auto-style1">&nbsp; Date / Time :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtDate" runat="server"
                                ToolTip="Click To Select Date" Width="100px" TabIndex="1"
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="txtTime" TabIndex="6" runat="server" Width="100px" ></asp:TextBox>
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTimeStart" runat="server" ControlToValidate="txtTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>
                        </td>
                    </tr> 
                    <tr>
                        <td style="text-align: right; vertical-align: central" class="auto-style1">Notes
                               : 
                        </td>
                        <td>
                            <asp:TextBox ID="txtPrescription" CssClass="requiredField" runat="server" TextMode="MultiLine" TabIndex="3" Height="100px" Width="600px" MaxLength="1000"></asp:TextBox>
                            <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">(Max 1000 Char.)</asp:Label>
                        </td>
                    </tr>
                
                    <tr>
                        <td style="text-align: right; vertical-align: top" class="auto-style1"></td>
                        <td>
                            <asp:Label ID="lblID" runat="server" Visible="FALSE"></asp:Label>
                        </td>
                    </tr>


                </table>

            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">

                <asp:Button ID="Btnsave" runat="server" OnClick="btnSave_Click" Text="save" TabIndex="5" CssClass="ItDoseButton" OnClientClick="return note(event,'Save')" />
                <asp:Button ID="btnUpdate" TabIndex="6" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" OnClientClick="return note(event,'Update');" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" TabIndex="7" runat="server" Text="Cancel" CssClass="ItDoseButton" Visible="false" OnClick="btnCancel_Click" />
                <asp:Button ID="btnPrint" TabIndex="8" runat="server" Text="Print" Visible="false" CssClass="ItDoseButton" OnClick="btnPrint_Click" />
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="height: 19px;">
                    Results
                </div>
                <table id="tbNursingprogress">
                    <tr>
                        <td>
                            <div style="text-align: center;">
                                <asp:GridView ID="grdNursing" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdNursing_RowDataBound" OnRowCommand="grdNursing_RowCommand">

                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>

                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>

                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lbldate" runat="server" Text='<%#Eval("DATETIME") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("TIME") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                      
                                        <asp:TemplateField HeaderText="Notes">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNursing" runat="server" Text='<%#Eval("NursingNotes") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
 
                                        <asp:TemplateField HeaderText="Entry By">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="Update DateTime">
                                            <ItemTemplate>
                                                <asp:Label ID="lblupdatedatetime" runat="server" Text='<%#Eval("UpdateDateTime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Edit">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreateUserID") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="FALSE"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                    </Columns>
                                    <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="5" />
                                </asp:GridView>
                            </div>

                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>

