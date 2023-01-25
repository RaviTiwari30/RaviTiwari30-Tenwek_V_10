<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UCStoreReportSearchCriteria.ascx.cs" Inherits="Design_Controls_UCStoreReportSearchCriteria" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script type="text/javascript">
    $(function () {
        $('.multiselect').multipleSelect({
            filter: true, keepOpen: false, width: 100
        });
        $('.multiselectitems').multipleSelect({
            selectAll: false,
            filter: true, keepOpen: false, width: 100
        });
        $(".multiselect,.multiselectitems").width('100%');
        $bindCenter(function () {
            //$bindDepartment(function () {
                //bindCategory();
                //bindSubcategory();
                //bindItems();
           // });
        });
    });
    function showhidefilter(center, department, supplier, category, subcategory, items, fromdate, todate, reporttype, StoreType)
    {
        if (center == 0) { $('.cen').hide(); }
        if (center == 1) { $('.cen').show(); }

        if (department == 0) { $('.department').hide(); }
        if (department == 1) { $('.department').show(); }

        if (supplier == 0) { $('.supplier').hide(); }
        if (supplier == 1) { $('.supplier').show(); $bindSupplier(function () { }); }

        if (category == 0) { $('.category').hide(); }
        if (category == 1) { $('.category').show(); }

        if (subcategory == 0) { $('.subcategory').hide(); }
        if (subcategory == 1) { $('.subcategory').show(); }

        if (items == 0) { $('.items').hide(); }
        if (items == 1) { $('.items').show(); }

        if (fromdate == 0) { $('.fromdate').hide(); }
        if (fromdate == 1) { $('.fromdate').show(); }

        if (todate == 0) { $('.todate').hide(); }
        if (todate == 1) { $('.todate').show(); }

        if (reporttype == 0) { $('.reporttype').hide(); }
        if (reporttype == 1) { $('.reporttype').show(); }
        //StoreType
        if (StoreType == 0) { $('.StoreType').hide(); }
        if (StoreType == 1) { $('.StoreType').show(); }
    }

    $.fn.listbox = function (params) {
        try {
            var elem = this.empty();
            if (params.defaultValue != null || params.defaultValue != '')
            $.each(params.data, function (index, data) {
                var dataAttr = {};
                var option = $(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]).attr('data', JSON.stringify(dataAttr));
                $(params.customAttr).each(function (i, d) { $(option).attr(d, data[d]); });
                elem.append(option);

            });
            if (params.selectedValue != null || params.selectedValue != '' || params.selectedValue != undefined)
                $(elem).val(params.selectedValue);


            if (params.isSearchAble || params.isSearchable) {
                $(elem).multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
        } catch (e) {
            console.error(e.stack);
        }
    };
    $bindCenter = function (callBack) {
        var empid = '<%=ViewState["EmpID"].ToString()%>';
        serverCall('../../../Design/Store/Services/CommonService.asmx/BindCenter', { EmployeeID: empid }, function (response) {
            if (response != "") {
                var $lstcenter = $('#lstcenter');
                $lstcenter.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
            }
            else {
                modelAlert('No Record Found');
            }
            callBack(true);
        });
    }
    $bindDepartment = function (callBack) {
        var DeptID = '<%=ViewState["Dept"].ToString()%>';
        var CentreID = Getmultiselectvalue($('#lstcenter'));
        serverCall('../../../Design/Store/Services/CommonService.asmx/BindDepartment', { DeptID: DeptID, CentreID: CentreID }, function (response) {
            if (response != "") {
                var $lstdepartment = $('#lstdepartment');
                $lstdepartment.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true });
            }
            else {
                modelAlert('No Record Found');
            }
            callBack(true);
        });
    }
    $bindSupplier = function (callBack) {
        var DeptID = '<%=ViewState["Dept"].ToString()%>';
        serverCall('../../../Design/Store/Services/CommonService.asmx/BindSupplier', { DeptID: DeptID }, function (response) {
            if (response != "") {
                var $lstsupplier = $('#lstsupplier');
                $lstsupplier.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LedgerNumber', textField: 'LedgerName', isSearchAble: true });
            }
            else {
                modelAlert('No Record Found');
            }
            callBack(true);
        });
    }
    function bindCategory() {
        var DepartmentID = Getmultiselectvalue($('#lstdepartment'));
            jQuery.ajax({
                url: "../../../Design/Store/Services/CommonService.asmx/BindCategory",
                data: '{ Cat: "' + DepartmentID + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    var stateData = jQuery.parseJSON(result.d);
                    if (stateData != null) {
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstCategory").append(jQuery("<option></option>").val(stateData[i].CategoryID).html(stateData[i].Name));
                        }
                        jQuery('[id*=lstCategory]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    }
                    else { modelAlert('No Record Found'); }
                },
                error: function (xhr, status) {
                    modelAlert("Error ");
                }
            });
    }
    function bindSubcategory() {
        var DepartmentID = Getmultiselectvalue($('#lstCategory'));
        jQuery.ajax({
            url: "../../../Design/Store/Services/CommonService.asmx/BindSubCategory",
            data: '{ CategoryID: "' + DepartmentID + '"}',
            type: "POST",
            timeout: 120000,
            async: false,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                var stateData = jQuery.parseJSON(result.d);
                if (stateData != null) {
                    if (stateData.length > 0) {
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstsubgroup").append(jQuery("<option></option>").val(stateData[i].SubCategoryID).html(stateData[i].Name));
                        }
                        jQuery('[id*=lstsubgroup]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    }
                }
                else { modelAlert('No Record Found'); }
            },
            error: function (xhr, status) {
                modelAlert("Error ");
            }
        });
    }
    function bindItems() {
        var DepartmentID = Getmultiselectvalue($('#lstsubgroup'));
            jQuery.ajax({
                url: "../../../Design/Store/Services/CommonService.asmx/BindItems",
                data: '{ subcategory: "' + DepartmentID + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    var stateData = jQuery.parseJSON(result.d);
                    if (stateData != null) {
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstitems").append(jQuery("<option></option>").val(stateData[i].ItemID).html(stateData[i].TypeName));
                        }
                        jQuery('[id*=lstitems]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    }
                },
                error: function (xhr, status) {
                    modelAlert("Error ");
                }
            });
        }
    function OnCentreChange() {
        jQuery('#<%=lstdepartment.ClientID%> option').remove();
        $bindDepartment(function () { });
    }
    function Onchangedepartment() {
        jQuery('#<%=lstCategory.ClientID%> option').remove();
       jQuery('#<%=lstsubgroup.ClientID%> option').remove();
       jQuery('#<%=lstitems.ClientID%> option').remove();
       jQuery('#lstCategory,#lstsubgroup,#lstitems').multipleSelect("refresh");
       bindCategory();
   }
   function Oncategorychange() {
       jQuery('#<%=lstsubgroup.ClientID%> option').remove();
       jQuery('#<%=lstitems.ClientID%> option').remove();
       jQuery('#lstsubgroup,#lstitems').multipleSelect("refresh");
       bindSubcategory();
   }
   function OnItemchange() {
       jQuery('#<%=lstitems.ClientID%> option').remove();
        jQuery('#lstitems').multipleSelect("refresh");
        bindItems();
   }
    function Getmultiselectvalue(controlvalue)
    {
        var DepartmentID = "";
        var input = "";
        var SelectedLaength = $(controlvalue).multipleSelect("getSelects").join().split(',').length;       
        if (SelectedLaength > 1)
            DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
        else {
            if ($(controlvalue).val() != null) {
                DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
            }
        }
        return DepartmentID;
    }
</script>
              <div class="row">
                <div class="col-md-24">
                    <div class="row rowborder">
                        <div class="cen">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:ListBox ID="lstcenter" CssClass="multiselect" SelectionMode="Multiple" placeholder="Select Center" runat="server" ClientIDMode="Static" onchange="OnCentreChange()"></asp:ListBox>
                        </div></div>
                       
                          <div class="StoreType">
                            <div class="col-md-3">
                                <label class="pull-left">Store Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="rdbMedical" type="radio" name="storetype"  checked="checked"   value="STO00001" class="pull-left"  />
				        <span class="pull-left">Medical Store</span>
				        <input id="rdbGeneral" type="radio" name="storetype" value="STO00002"   class="pull-left" />
				        <span class="pull-left">General Store</span>
                            </div>
                        </div>

                         <div class="department">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lstdepartment" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="Onchangedepartment()"></asp:ListBox>
                        </div></div>
                    </div>
                    <div class="row">
                        <div class="category">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Groups
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lstCategory" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="Oncategorychange()"></asp:ListBox>
                        </div></div>
                        <div class="subcategory">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Sub Groups
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lstsubgroup" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="OnItemchange()"></asp:ListBox>
                        </div></div>
                        <div class="items">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Items
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 items">
                            <asp:ListBox ID="lstitems" CssClass="multiselectitems" SelectionMode="Multiple" runat="server" ClientIDMode="Static" ></asp:ListBox>
                        </div></div>
                    </div>
                    <div class="row">
                        <div class="fromdate">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtdatefrom" runat="server" ClientIDMode="Static" ></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExteFromDate" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
                        </div></div>
                        <div class="todate">
                          <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtdateTo" runat="server" ClientIDMode="Static" ></asp:TextBox>
                           <cc1:CalendarExtender ID="calexetodate" TargetControlID="txtdateTo" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
                        </div></div>
                        <div class="reporttype">
                          <div class="col-md-3">
                        <label class="pull-left">Report Format</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                   <input id="rdopdf" type="radio" name="format"  checked="checked"   value="PDF" class="pull-left"  />
				        <span class="pull-left">&nbsp;&nbsp;PDF&nbsp;&nbsp;</span>
				        <input id="rdoExcel" type="radio" name="format" value="Excel"   class="pull-left" />
				        <span class="pull-left">&nbsp;&nbsp;Excel&nbsp;&nbsp;</span>
                    </div></div>
                    </div>
                    <div class="row">
                         <div class="supplier">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Supplier
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lstsupplier" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div></div>
                    </div>
                </div></div>
<script type="text/javascript">
    function getreport(serviceurl) {
        $.blockUI({ message: '<h3><img src="../../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
        var data = getsearchparameter();
        if (data[0].type == "V")
        {
            $.unblockUI();
            modelAlert(data[0].erroMessage, function () { $(data[0].control).focus(); });
            return false;
        }
        serverCall(serviceurl, { data: data }, function (response) {
            var responseData = JSON.parse(response);
            if (responseData.status) {
                $.unblockUI();
                window.open(responseData.responseURL);
            }
            else {
                $.unblockUI();
                modelAlert(responseData.message);
            }
        });
    }
</script>