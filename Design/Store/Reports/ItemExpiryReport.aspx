<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ItemExpiryReport.aspx.cs" Inherits="Design_Store_ItemExpiryReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <script type="text/javascript">
          function validateEntry() {
              if ($('#txtNoOf').val() == "")
                  return false;
              else
                  return true;
          }
          $(function () {
              showhidefilter(1, 1, 1, 1, 1, 1, 0, 0, 1,1);
              //showhidefilter(center, department, supplier, category, subcategory, item, fromdate, todate,reportype);
          });
          function getsearchparameter() {
              if (Getmultiselectvalue($('#lstcenter')) == '')
                  return [{ erroMessage: 'Please Select Center', type: 'V' }];
              if (Getmultiselectvalue($('#lstdepartment')) == '')
                  return [{ erroMessage: 'Please Select Department', type: 'V' }];
              if (!validateEntry())
                  return [{ erroMessage: 'Please Enter No of Days/Months/Years.', type: 'V' }];
              var radio = $.trim($("#<%=rblStatus.ClientID%> input[type=radio]:checked").val())
              var searchparameter = new Array();
              searchparameter[0] = Getmultiselectvalue($('#lstcenter'));
              searchparameter[1] = Getmultiselectvalue($('#lstdepartment'));
              searchparameter[2] = Getmultiselectvalue($('#lstCategory'));
              searchparameter[3] = Getmultiselectvalue($('#lstsubgroup'));
              searchparameter[4] = Getmultiselectvalue($('#lstitems'));
              searchparameter[5] = $('#txtNoOf').val();
              searchparameter[6] = $('#ddlDatePart').val();
              searchparameter[7] = $('input[type=radio][name=storetype]:checked').val() == "STO00001" ? "STO00001" : "STO00002";
              searchparameter[8] = $('input[type=radio][name=format]:checked').val() == "PDF" ? "PDF" : "EXCEL";
              searchparameter[9] = Getmultiselectvalue($('#lstsupplier'));
              searchparameter[10] = radio;
              return searchparameter;
          }
          var reportprint = function () {
              getreport('ItemExpiryReport.aspx/Store_Get_ExpiryDetail');
          }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager2" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Item Expiry Report</b><br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
        </div>
          <div class="POuter_Box_Inventory">
                            <div class="row">
             <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" /></div>
              <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                    <div class="col-md-3">
                       <label class="pull-left">Number</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtNoOf" runat="server" ClientIDMode="Static" Text="1" CssClass="requiredField"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtNoOf"
                                FilterType="Numbers" Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-3">
                         <asp:DropDownList ID="ddlDatePart" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Select Date Part">
                            <asp:ListItem Text="DAYS" Value="D" Selected="True" />
                            <asp:ListItem Text="MONTHS" Value="M" />
                            <asp:ListItem Text="YEARS" Value="Y" />
                        </asp:DropDownList>
                    </div>
                   <div class="col-md-3">
                        <label class="pull-left">Expiry Status</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                     <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                            <asp:ListItem Selected="True" Text="Expired" Value="P"></asp:ListItem>
                            <asp:ListItem Text="About To Expired" Value="F"></asp:ListItem>
                    </asp:RadioButtonList>
                    </div>
              </div></div></div>
        </div>
          
        <div class="POuter_Box_Inventory" style="text-align: center;">
              <input type="button" id="btnsearch" onclick="reportprint()" value="Report"/>
        </div>

    </div>
</asp:Content>

