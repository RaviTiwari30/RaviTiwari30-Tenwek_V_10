<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="IndentSearchForStore.aspx.cs" Inherits="Design_Store_IndentSearchForStore"
     %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
  <script type="text/javascript" >

      $(function () {
          $('#DateFrom').change(function () {
              ChkDate();

          });

          $('#DateTo').change(function () {
              ChkDate();
          });

      });

      function getDate() {

          $.ajax({
              url: "../Common/CommonService.asmx/getDate",
              data: '{}',
              type: "POST",
              async: true,
              dataType: "json",
              contentType: "application/json; charset=utf-8",
              success: function (mydata) {
                  var data = mydata.d;
                  $('#btnSearchIndent').attr('disabled', 'disabled');
                  $('#<%=btnSN.ClientID %>').attr('disabled', 'disabled');
                  $('#<%=btnRN.ClientID %>').attr('disabled', 'disabled');
                  $('#<%=btnNA.ClientID %>').attr('disabled', 'disabled');
                  $('#<%=btnA.ClientID %>').attr('disabled', 'disabled');
                  $('#<%=grdIndentSearch.ClientID %>').hide();
                  $("#tbAppointment table").remove();

                  return;
              }
          });
      }

      function ChkDate() {

          $.ajax({

              url: "../Common/CommonService.asmx/CompareDate",
              data: '{DateFrom:"' + $('#DateFrom').val() + '",DateTo:"' + $('#DateTo').val() + '"}',
              type: "POST",
              async: true,
              dataType: "json",
              contentType: "application/json; charset=utf-8",
              success: function (mydata) {
                  var data = mydata.d;
                  if (data == false) {
                      //$('#lblMsg').text('To date can not be less than from date!');
                      DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                      getDate();

                  }
                  else {
                      $('#lblMsg').text('');
                      $('#btnSearchIndent').removeAttr('disabled');
                      $('#<%=btnSN.ClientID %>').removeAttr('disabled');
                      $('#<%=btnRN.ClientID %>').removeAttr('disabled');
                      $('#<%=btnNA.ClientID %>').removeAttr('disabled');
                      $('#<%=btnA.ClientID %>').removeAttr('disabled');
                  }
              }
          });

      }
      
      
   
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Search Requisition</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Requisition Criteria</div>
            <div  style="text-align: center; height: 111px; margin-left:90px;" >
                
                <table style="width: 720px">
                    <%--<tr><td colspan='3'align="center" style="height: 22px">
</td></tr>--%>
                    <tr>
                        <td align="right">
                            Date From:
                        </td>
                        <td align="left">
                            
                            <asp:TextBox ID="DateFrom" runat="server" ClientIDMode="Static" Width="139px" ></asp:TextBox> 
        <cc1:CalendarExtender ID="frmdate" TargetControlID="DateFrom" Format="dd-MMM-yyyy" 
runat="server"></cc1:CalendarExtender>
  


                        </td>
                        <td align="right">
                            Date To:
                        </td>
                        <td align="left">
                            

                            <asp:TextBox ID="DateTo" runat="server" ClientIDMode="Static" Width="139px" ></asp:TextBox> 
        <cc1:CalendarExtender ID="todalcal" TargetControlID="DateTo" Format="dd-MMM-yyyy" 
runat="server"></cc1:CalendarExtender>
  


                        </td>
                    </tr>
                    <tr>
                        <td style="height: 26px" align="right">
                            Department:
                        </td>
                        <td style="height: 26px" align="left">
                            <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="ItDoseLabel"
                                Width="144px">
                            </asp:DropDownList>
                        </td>
                       
                        <td style="height: 26px" align="right">
                            Requisition Number:
                        </td>
                        <td style="height: 26px; width: 187px;" align="left">
                            <asp:TextBox ID="txtIndentNoToSearch" runat="server" 
                                Width="139px"></asp:TextBox>
                        </td>
                    </tr>
                    <br />
                    <tr>
                        <td style="height: 26px;text-align: center;" colspan='4' >
                            <asp:Button ID="btnSearchIndent" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnSearchIndent_Click1" ClientIDMode="Static" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="content" style="text-align: center;">
            <div id="colorindication" runat="server" style="margin-left:90px;">
                <table width="75%">
                    <tr>
                        <td style="height: 22px">
                            &nbsp;<asp:Button ID="btnSN" runat="server" Width="20px" Height="20px" BackColor="LightBlue"
                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnSN_Click" ToolTip="Click for Open Requisition" style="cursor:pointer;"  />
                        </td>
                        <td style="text-align: left; height: 22px;">
                            Pending
                        </td>
                        <td style="height: 22px">
                            <asp:Button ID="btnRN" runat="server" Width="20px" Height="20px" BackColor="green"
                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnRN_Click" ToolTip="Click for Close Requisition" style="cursor:pointer;" />
                        </td>
                        <td style="text-align: left; height: 22px;">
                            Issued
                        </td>
                        <td style="height: 22px">
                            &nbsp;<asp:Button ID="btnNA" runat="server" Width="20px" Height="20px" BackColor="LightPink"
                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnNA_Click" ToolTip="Click for Reject Requisition" style="cursor:pointer;" />
                        </td>
                        <td style="text-align: left; height: 22px;">
                            Reject
                        </td>
                        <td style="height: 22px">
                            &nbsp;<asp:Button ID="btnA" runat="server" Width="20px" Height="20px" BackColor="Yellow"
                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnA_Click" ToolTip="Click for Partial Requisition" style="cursor:pointer;" />
                        </td>
                        <td style="text-align: left; height: 22px; width: 145px;">
                            &nbsp;Partial
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results</div>
            <div style="text-align: center">
                <asp:GridView ID="grdIndentSearch" runat="server" CssClass="GridViewStyle" OnRowCommand="gvGRN_RowCommand"
                    PageSize="8" AutoGenerateColumns="False" 
                    Width="698px" OnRowDataBound="grdIndentSearch_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Requisition Date">
                            <ItemTemplate>
                                <asp:Label ID="lblIndentDate" runat="server" Text='<%# Eval("dtEntry")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Requisition No.">
                            <ItemTemplate>
                                <asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="115px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Department">
                            <ItemTemplate>
                                <asp:Label ID="lblToDepartment" runat="server" Text='<%# Eval("LedgerName") %>'></asp:Label>
                                <%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IssueNo" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblIssueNo" runat="server" Text='<%# Eval("IssueNo") %>'></asp:Label>
                                <%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IssueDate" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblIssueDate" runat="server" Text='<%# Eval("IssueDate") %>'></asp:Label>
                                <%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                    ImageUrl="~/Images/view.gif" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("salesno")+"#"+Eval("TrasactionTypeID")+"#"+Eval("StatusNew")  %>' />
                                <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="StatusNew" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblStatusNew" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView1" runat="server" CausesValidation="false" CommandName="APrint"
                                    ImageUrl="~/Images/print.gif" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("salesno")+"#"+Eval("TrasactionTypeID")+"#"+Eval("StatusNew")  %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                &nbsp;&nbsp;</div>
        </div>
    </div>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display: none;
        width: 900px; height: 350px;" ScrollBars="Auto">
        <div>
            <table>
                <tr>
                    <td style="text-align: center;">
                        <label>
                            <strong>Requisition Detail:</strong></label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;">
                        <asp:GridView ID="grdIndentdtl" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            Width="698px" OnRowDataBound="grdIndentdtl_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Requisition No" DataField="IndentNo" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Department From" DataField="DeptFrom" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Department To" DataField="DeptTo" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Item Name" DataField="ItemName" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Unit Type" DataField="UnitType" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Requested Qty" DataField="ReqQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Received Qty" DataField="ReceiveQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Pending Qty" DataField="PendingQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Rejected Qty" DataField="RejectQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Narration" DataField="Narration" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Date" DataField="DATE" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Raised By" DataField="EmpName" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Issued By" DataField="IssueBy" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Rejected By" DataField="RejectBy" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:TemplateField HeaderText="StatusNew" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatusNew1" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;">
                        <asp:Button ID="btnCancel1" runat="server" Text="Cancel" CssClass="ItDoseButton" />
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel1" PopupControlID="Panel2"
        TargetControlID="btn1" X="50" Y="100">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton"/></div>
</asp:Content>
