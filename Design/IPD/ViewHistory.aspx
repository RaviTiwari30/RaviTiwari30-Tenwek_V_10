<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewHistory.aspx.cs" Inherits="Design_IPD_ViewHistory" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" href="../../Styles/framestyle.css" />
        <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>

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
        .accordion {
        }

        .accordionHeader {
            border: 1px solid #2F4F4F;
            color: Black;
            background-color: lightsalmon;
            font-family: Arial, Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            padding: 5px;
            margin-top: 5px;
            cursor: pointer;
        }

        .accordionHeaderSelected {
            border: 1px solid #2F4F4F;
            color: Black;
            background-color: salmon;
            font-family: Arial, Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            padding: 5px;
            margin-top: 5px;
            cursor: pointer;
        }

        .accordionContent {
            background-color: white;
            border: 1px dashed #2F4F4F;
            border-top: none;
            padding: 5px;
            padding-top: 10px;
        }
    </style>
    <script type="text/javascript" language="javascript" src="../../Scripts/Search.js"></script>
    <script src="../../Scripts/jquery-1.7.1.js" type="text/javascript" language="javascript"></script>

    <script type="text/javascript">
        function OPDPrint(trtransactionid) {
            var TID = $.trim($(trtransactionid).closest('tr').find("#trtransactionid").text());
            var LnxNo = 1;
            location.href = '../CPOE/PrintOut.aspx?TID=' + TID + '&LnxNo=' + LnxNo + ' ';
        }

    </script>
     <script type="text/javascript">
         function IPDPrint(rowid) {
             var IPTID = $.trim($(rowid).closest('tr').find("#IPDtrtransactionid").text());
             location.href = '../IPD/IPDPrintOut.aspx?TID=' + IPTID + ' ';
         }
         </script>
     <script type="text/javascript">
         function EmergencyPrint(rowid) {
             var EMTID = $.trim($(rowid).closest('tr').find("#Emergencytrtransactionid").text());
             location.href = '../Emergency/EmergencyPrintOut.aspx?TID=' + EMTID + ' ';
         }
         </script>
</head>
<body>    <form id="form1" runat="server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            
            <div class="POuter_Box_Inventory" style="text-align: center;">
               
                   
                        <b>View History</b><br />
                   
                
              
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
          
            <asp:Label ID="abc" runat="server" Text="."></asp:Label>
            <div id="accordion">
                <cc1:Accordion ID="Accordion1" runat="server" CssClass="accordion" HeaderCssClass="accordionHeader" 
                    HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent">
                   
                    <Panes>
                        <cc1:AccordionPane ID="AccordionPane1" runat="server" Visible="false">
                            <Header>
                            OPD History</Header>
                            <Content>
                                <asp:GridView ID="grdOPDHistory" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Consultation Date">
                                            <ItemTemplate>
                                                <%#Eval("DateVisit") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Doctor Name">
                                            <ItemTemplate>
                                                <%#Eval("DName") %>
<table>
                                                    <tr id="trtransactionid1">
                                                        <td id="trtransactionid" class="GridViewHeaderStyle" scope="col" style="display:none " >
                                                             <%#Eval("TransactionID") %>
                                                       </td 
                                                            
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="View History">
                                            <ItemTemplate>
                                                <table>              
                            <input type="button" class="ItDoseButton" value="View"  onclick="OPDPrint(this);" />
                                                </table>
                                                    </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        
                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                   <cc1:AccordionPane ID="AccordionPane2" runat="server" Visible="true">
                            <Header>
                            IPD History</Header>
                            <Content>
                                <asp:GridView ID="grdIPDHistory" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                        </asp:TemplateField>
                                           <asp:TemplateField HeaderText="IPD No.">
                                            <ItemTemplate>
                                                <%#Eval("IPD") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                              <asp:TemplateField HeaderText="Doctor Name">
                                            <ItemTemplate>
                                                <%#Eval("DoctorName") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Admission Date">
                                            <ItemTemplate>
                                                <%#Eval("AdmissionDate") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Discharge Date">
                                            <ItemTemplate>
                                                <%#Eval("DischargeDate") %>
                                                <table>
                                                    <tr id="IPDtrtransactionid1">
                                                        <td id="IPDtrtransactionid" class="GridViewHeaderStyle" scope="col" style="display:none " >
                                                             <%#Eval("TransactionID") %>
                                                       </td 
                                                            
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="View History">
                                            <ItemTemplate>
                                                <table>
                                                 <input type="button" class="ItDoseButton" value="View IPD History"  onclick="IPDPrint(this)"/>
                                            </table>
                                                    </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        
                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                           <cc1:AccordionPane ID="AccordionPane3" runat="server" Visible="false">
                            <Header>
                            Emergency History</Header>
                            <Content>
                                <asp:GridView ID="grdEmergency" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                        </asp:TemplateField>
                                           <asp:TemplateField HeaderText="Doctor Name">
                                            <ItemTemplate>
                                                <%#Eval("DName") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Admission Date">
                                            <ItemTemplate>
                                                <%#Eval("AppDate") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Discharge Date">
                                            <ItemTemplate>
                                              <%--  <%#Eval("DischargeDate") %>--%>
                                                <table>
                                                    <tr id="Emergencytrtransactionid1">
                                                        <td id="Emergencytrtransactionid" class="GridViewHeaderStyle" scope="col" style="display:none " >
                                                             <%#Eval("TransactionID") %>
                                                       </td 
                                                            
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="View History">
                                            <ItemTemplate>
                                                <table>
                                                 <input type="button" class="ItDoseButton" value="View Emergency History"  onclick="EmergencyPrint(this)"/>
                                            </table>
                                                    </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        </asp:TemplateField>
                                        
                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>


                         <cc1:AccordionPane ID="AccordionPane4" runat="server" Visible="true">
                            <Header>
                            OT History</Header>
                            <Content>
                                <asp:GridView ID="grdothistory" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle"/>
                                        </asp:TemplateField>
                                           <asp:TemplateField HeaderText="OT Number">
                                            <ItemTemplate>
                                                <%#Eval("OTNumber") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="SurgeryName">
                                            <ItemTemplate>
                                                <%#Eval("SurgeryName") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="SurgeryDate">
                                            <ItemTemplate>
                                                   <%#Eval("SurgeryDate") %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Surgery Time">
                                            <ItemTemplate>
                                                 <%#Eval("SurgeryTiming") %>
                                                    </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                         <asp:TemplateField HeaderText="Confirmed Date & Time">
                                            <ItemTemplate>
                                                 <%#Eval("ConfirmedDate") %>
                                                    </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        
                                    </Columns>
                                </asp:GridView>
                            </Content>
                        </cc1:AccordionPane>
                    </Panes>
                    </cc1:Accordion>

        </div>
            </div>
    </form>
</body>
</html>
