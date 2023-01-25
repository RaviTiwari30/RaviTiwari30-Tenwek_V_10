<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ConsumeGatherReport.aspx.cs" Inherits="Design_Store_ConsumeGatherReport" MasterPageFile="~/DefaultHome.master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            showhidefilter(1, 1, 0, 1, 1, 1, 1, 1, 1, 1);
            //showhidefilter(center, department, supplier, category, subcategory, item, fromdate, todate,reportype,storetype);
        });
        function getsearchparameter() {
            if (Getmultiselectvalue($('#lstcenter')) == '')
                return [{ erroMessage: 'Please Select Center', type: 'V' }];
            if (Getmultiselectvalue($('#lstdepartment')) == '')
                return [{ erroMessage: 'Please Select Department', type: 'V' }];

            var searchparameter = new Array();
            searchparameter[0] = Getmultiselectvalue($('#lstcenter'));
            searchparameter[1] = Getmultiselectvalue($('#lstdepartment'));
            searchparameter[2] = Getmultiselectvalue($('#lstCategory'));
            searchparameter[3] = Getmultiselectvalue($('#lstsubgroup'));
            searchparameter[4] = Getmultiselectvalue($('#lstitems'));
            searchparameter[5] = $('input[type=radio][name=storetype]:checked').val() == "STO00001" ? "STO00001" : "STO00002";
            searchparameter[6] = $('input[type=radio][name=format]:checked').val() == "PDF" ? "PDF" : "EXCEL";
            searchparameter[7] = $('#txtdatefrom').val();
            searchparameter[8] = $('#txtdateTo').val();
            searchparameter[9] = $('#ddlconsumetype').val();
            return searchparameter;
        }
        var reportprint = function () {
            getreport('ConsumeGatherReport.aspx/Store_Get_ConsumeData');
        }
    </script>



    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">

            <div style="text-align: center;">
                <b>Consumption Report</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>

        </div>
        <div class="POuter_Box_Inventory">
                <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Consume Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlconsumetype">
                                <option value="0" selected="selected">ALL</option>
                                <option value="C">Consume</option>
                                <option value="G">Gather</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <input type="button" id="btnsearch" onclick="reportprint()" value="Report"/>
        </div>
    </div>
</asp:Content>
