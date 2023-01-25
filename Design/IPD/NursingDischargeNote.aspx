<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NursingDischargeNote.aspx.cs" Inherits="Design_IPD_NursingDischargeNote" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
     <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    
</head>
<body>
    <form id="form1" runat="server">
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
        <script type="text/javascript" >
            $(document).ready(function () {
                var MaxLength = 2000;
                //$("#txtnote").bind("cut copy paste", function (event) {
                //    event.preventDefault();
                //});
                //$("#txtnote").bind("keypress", function (e) {
                //    // For Internet Explorer  
                //    if (window.event) {
                //        keynum = e.keyCode
                //    }
                //        // For Netscape/Firefox/Opera  
                //    else if (e.which) {
                //        keynum = e.which
                //    }
                //    keychar = String.fromCharCode(keynum)
                //    if (e.keyCode == 39 || keychar == "'") {
                //        return false;
                //    }
                //    if ($(this).val().length >= MaxLength) {
                //        if (window.event)//IE
                //        {
                //            e.returnValue = false;
                //            return false;
                //        }
                //        else//Firefox
                //        {
                //            e.preventDefault();
                //            return false;
                //        }
                //    }
                //});
            });

            function note() {
                if ($.trim($("#<%=txtnote.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Discharge Advice');
                    $("#<%=txtnote.ClientID%>").focus();
                    return false;
                }
                $("#<%=lblMsg.ClientID%>").text('');
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('btnSave', '');
            }
        </script>
      <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
       <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Nurses Discharge Note</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
                <table  style="width:100%;border-collapse:collapse">
                    <tr>
                        <td    style="width: 30%; font-size: 10pt;text-align:right">
                            Date :&nbsp;
                        </td>
                        <td style="font-size: 10pt;text-align:left">
                            <asp:TextBox ID="txtdate" runat="server" ToolTip="Click to Select Date" Width="90px"></asp:TextBox>
                             <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtdate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                       
                        <td  style="width: 40%; font-size: 10pt;text-align:left ">
                        </td>
                    </tr>
            
         
                    <tr style="font-size: 10pt">
                        <td style="text-align:right; vertical-align:top"  >Discharge Advice :&nbsp;
                        </td>
                        <td  colspan="2" style="width: 30%;font-size: 12px;text-align:left">
                        <asp:TextBox ID="txtnote" runat="server" TextMode="MultiLine"  Height="58px" Width="510px"></asp:TextBox>
                      <asp:Label ID="lbl1" ForeColor="Red" runat="server" Font-Size="10px" Text="*(Max 200 char.)"></asp:Label>
                            
                            
                            
                        </td>
                    </tr>
                  
                    
                    <tr style="font-size: 10pt">
                        <td style="text-align:right; vertical-align:top"  >Issue Items :
                        </td>
                        <td  colspan="2" style="width: 30%;font-size: 12px;text-align:left">
                        <asp:TextBox ID="txtIssueItem" runat="server" TextMode="MultiLine"  Height="58px" Width="510px"></asp:TextBox>
                        </td>
                    </tr>
                  
                    
                    <tr style="font-size: 10pt">
                        <td style="text-align:right; vertical-align:top"  >Next Visit :&nbsp;</td>
                        <td  colspan="2" style="width: 30%;font-size: 12px;text-align:left">
                            <asp:TextBox ID="txtNextVisit" runat="server" ToolTip="Click to Select Date" Width="90px"></asp:TextBox>
                             <cc1:CalendarExtender ID="txtNextVisitCal" runat="server" TargetControlID="txtNextVisit" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                  
                    
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save"  
                    TabIndex="7" onclick="btnSave_Click"  OnClientClick="return note()"/>
            
        </div>
        <asp:Panel ID="pnlhide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Nurses Discharge Note
                </div>
               
                    <asp:GridView  ID="grid" runat="server" CssClass="GridViewStyle" 
                        AutoGenerateColumns="false" 
                        OnRowDeleting="grid_RowDeleting" OnRowDataBound="grid_RowDataBound">
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
                            <asp:TemplateField HeaderText="Discharge Advice" HeaderStyle-Width="700px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                   <asp:Label ID="lblpro" runat="server" Text='<%#Eval("ProgressNote") %>'></asp:Label>
                                     <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblUserID" Text='<%#Eval("UserID") %>' runat="server" Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:BoundField DataField="Issueitem" HeaderText="Issue Items" HeaderStyle-Width="700px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                             <asp:BoundField DataField="NextVisit" HeaderText="Next Visit" HeaderStyle-Width="700px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="EntryBy" HeaderText="Entry By" HeaderStyle-Width="200px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                   <asp:CommandField ShowDeleteButton="True" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderText="Remove" ItemStyle-HorizontalAlign="Center"
                                HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image" DeleteText="Remove Procedure"    DeleteImageUrl="~/Images/Delete.gif"/>
                        </Columns>
                    </asp:GridView>
                    <br />
                  
               
            </div>
        </asp:Panel>
       
        
        
    </div>
    </form>
</body>
</html>
