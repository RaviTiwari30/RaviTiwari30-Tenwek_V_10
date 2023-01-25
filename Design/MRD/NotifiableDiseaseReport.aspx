<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NotifiableDiseaseReport.aspx.cs"
    MasterPageFile="~/DefaultHome.master" Inherits="Design_MRD_NotifiableDiseaseReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        $(function () {
            $('#ucDateFrom').change(function () {
                ChkDate();

            });

            $('#ucDateTo').change(function () {
                ChkDate();

            });

        });

       

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucDateFrom').val() + '",DateTo:"' + $('#ucDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnissue.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=btnexcel.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnissue.ClientID %>').removeAttr('disabled');
                        $('#<%=btnexcel.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
        function ClosedivInvDetil () {
            $('#divInvestigationDetail').closeModel();
        }
 
    </script>
    <div>
        <div id="Pbody_box_inventory">
         <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
            <div class="POuter_Box_Inventory">
                    <div style="text-align: center;">
                        <b>Notifiable Disease Reports
                            
                        </b><br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                   
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Patient&nbsp;</div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">From Date </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                     <asp:TextBox ID="ucDateFrom" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                    TabIndex="1" Width="179px" CssClass="ItDoseTextinputText"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucDateFrom" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3"></div>
                            <div class="col-md-5"></div>
                               <div class="col-md-3">
                                <label class="pull-left">To Date </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                  <asp:TextBox ID="ucDateTo" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                    TabIndex="2" Width="170px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucDateTo" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>

                        </div>
                    </div>
                    <div class="col-md-1"></div>
                    
                </div>
                  </div>
                
                    
            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align:center">
                        <div class="col-md-24">
                                   <asp:Button ID="btnissue" Text="Report" CssClass="ItDoseButton" runat="server" ValidationGroup="doc"
                                    OnClick="btnissue_Click" />
                                <asp:Button ID="btnexcel" Text="Export To Excel" CssClass="ItDoseButton" runat="server"
                                    ValidationGroup="doc" OnClick="btnexcel_Click" />
                        </div>

                    </div>
            </div>
                
                    <table width="100%">
                        <tr>
                            <td align="center" colspan="5" style="height: 284px">
                                <asp:Label ID="lbldetail" runat="server" Font-Bold="True" Font-Size="10pt" Width="187px"></asp:Label>
                                &nbsp; &nbsp;
                                <asp:Panel ID="Panel1" runat="server" Height="250px" Width="800px" ScrollBars="Auto">
                                    <asp:GridView ID="grddetail" CssClass="GridViewStyle" Width="800px" runat="server"
                                        AutoGenerateColumns="false" OnRowCommand="grddetail_RowCommand">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Disease Name" ItemStyle-CssClass="GridViewItemStyle"
                                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDiseaseName" runat="server" Text='<%#Eval("DiseaseName")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Quantity" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblQty" runat="server" Text='<%#Eval("Qty") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Year" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblYrOfDis" runat="server" Text='<%#Eval("YrOfDis") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Month" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblMthOfDis" runat="server" Text='<%#Eval("MthOfDis") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="View">
                                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.gif"
                                                        CommandArgument='<%#Eval("DiseaseID")+"#"+Eval("YrOfDis")+"#"+Eval("MthOfDis") %>'
                                                        CausesValidation="false" CommandName="View" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:GridView>
                                </asp:Panel>
                             
                            </td>
                        </tr>
                    </table>
          
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton"/>
    </div>
    
   

    <div id="divInvestigationDetail" class="modal fade " style="display:none">
             <div class="modal-dialog">
                  <div class="modal-content" style="background-color: white; width: 1000px; height: 221px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divInvestigationDetail" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Investigation Detail</h4>
                    </div>
                       <div class="modal-body">
                            <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-24">
                                        <asp:GridView ID="grdDiseaseDetail" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdDiseaseDetail_RowCommand" Width="850px">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Date" HeaderText="Date">
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Investigation">
                            <ItemTemplate>
                                <asp:Label ID="lblInvestigationname" runat="server" Text='<%#Eval("Name")%>' Width="250px"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Investigation" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lblInvestigationID" runat="server" Text='<%#Eval("Investigation_ID") %>'
                                    Width="250px"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Report Type">
                            <ItemTemplate>
                                <asp:Label ID="lblReportType" runat="server" Text='<%#Eval("ReportType") %>' Width="75px"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View Report">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandArgument='<%#Eval("Test_ID")+"#"+Eval("LedgerTransactionNo")+"#"+Eval("ReportType")+"#"+Eval("Result_Flag")+"#"+Eval("TransactionID")+"#"+Eval("LabType") %>'
                                    CommandName="ViewRpt" ImageUrl="~/Images/view.gif" ToolTip="View Report" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View Patient Detail">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbViewPt" runat="server" CausesValidation="false" CommandArgument='<%#Eval("TransactionID")%>'
                                    CommandName="ViewPt" ImageUrl="~/Images/view.GIF" ToolTip="View Patient Detail" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                                    </div>

                                </div>

                            </div>
                                <div class="col-md-1"></div>
                                <div class="row">

                                    </div>
                                </div>
                           </div>
                           <div class="modal-footer">
                      <div class="row" style="text-align:center">
                     <div class="col-md-24" style="text-align:center">
                     <asp:Button  ID="btnCloseinvestigtiondetail" runat="server" ClientIDMode="Static" Text="Close" CssClass="ItDoseButton" OnClientClick="ClosedivInvDetil()"/>
                          </div>
                      </div>
                      
                      </div>
                      </div>
                 </div>
        </div>
</asp:Content>
