<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TokenGenerationMaster.aspx.cs" Inherits="Design_EDP_TokenGenerationMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"> </script>
    <script type="text/javascript" src="../../Scripts/Message.js"> </script>
     <style type="text/css">

        .hidden {
            display: none !important;
        }
    </style>
    <script type="text/javascript">
        $(function () {
           
            getCategory();
            getSubCategory();
            getCentre(function (CentreID) {
                bindModality(0,CentreID, function () {

                });
            });
            $("#btnSave").attr("disabled", true);
            $("#btnAdd").attr("disabled", true);
            $('#ddlCategory').bind("change", function () {
                if (!$("#rdoCat").is(':checked')) {
                    getSubCategory();
                }
                else {
                    $("#btnAdd").removeAttr("disabled");
                }
                 
                $("#txtGroupName").val('');
                
                if ($('#ddlCategory').val() != "0") {
                    ShowGridByCategoryWise($('#ddlCategory').val());
                  //  $("#txtGroupName").val($('#ddlCategory option:selected').text());
                }
            });
        });

        var getCentre = function (callback) {
            ddlCentre = $('#ddlCentre');
            serverCall('../Common/CommonService.asmx/BindAllCentre', {}, function (response) {
                var responseData = JSON.parse(response);
                ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false });
                callback(ddlCentre.val());
            });
        }


        function ShowGridByCategoryWise(categoryId) {
            $.ajax({
                type: "POST",
                url: 'TokenGenerationMaster.aspx/BindDetail',
                data: '{CategoryID:"' + categoryId + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                processData: false,
            }).done(function (response) {
                CategoryDetail = jQuery.parseJSON(response.d);
                if (CategoryDetail != null) {
                    var output = $('#tb_SearchCategoryDetail').parseTemplate(CategoryDetail);
                    $('#groupOutput').html(output);
                    $('#groupOutput').show();
                }
                else {
                    $('#groupOutput').hide();
                }
            });
        }

        function getCategory() {
            $('#ddlCategory option').remove();
            $.ajax({
                url: "../EDP/Services/Item_Master.asmx/getCategory",
                data: '{ }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    CategoryData = jQuery.parseJSON(result.d);
                    if (CategoryData.length == 0) {
                        $('#ddlCategory').append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        
                        $('#ddlCategory').append($("<option></option>").val("0").html("---Select---"));
                        for (i = 0; i < CategoryData.length; i++) {
                            if (CategoryData[i].ConfigID == 3) {
                                $('#ddlCategory').append($("<option></option>").val(CategoryData[i].CategoryID).html(CategoryData[i].Name));
                            }
                        }
                    }
                },
                error: function (xhr, status) {
                    $('#ddlCategory').prop("disabled", false);
                }
            });
        }



        function addText(elem) {
            debugger;
            $('.checkboxlist-subcategory').find('input[type=checkbox]').not($(elem)).prop('checked', false);

            bindModality($(elem).val(),$('#ddlCentre').val(), function () { });
            var groupName = $('#txtGroupName').val();

            if ($(elem).prop("checked")) {
                $('#txtGroupName').val(groupName + '#' + $(elem).next().text());
            }
            else {
                $('#txtGroupName').val(groupName.replace('#' + $(elem).next().text(), ""));
            }
        }
        function getSubCategory() {
            $("#ddlSubCategory option").remove();

            if ($('#ddlCategory').val() == "0")
            {
                return false;
            }
            $.ajax({
                url: "../EDP/Services/Item_Master.asmx/getSubCategory",
                data: '{CategoryID:"' + $('#ddlCategory').val() + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    var SubCatDivChkbox = $(".checkboxlist-subcategory");
                    $(SubCatDivChkbox).html('');
                    $('#txtGroupName').val('');
                    var table = $('<table id="tbodyid" class="FixedTables" cellspacing="0" style="width:100%;"></table>');
                    SubCategoryData = jQuery.parseJSON(result.d);
                    if (SubCategoryData.length == 0) {
                        modelAlert("Subcategory not found");
                        $("#btnAdd").attr("disabled", true);
                        $(SubCatDivChkbox).append($("<input type='checkbox' />").val("0"));
                    }
                    else {
                        $("#btnAdd").removeAttr("disabled");
                        $('#divSubCat').show();
                        for (i = 0; i < SubCategoryData.length; i++) {
                            var rows = $("#tbodyid tr").length;
                            var cols = $("#tbodyid tr:last td").length;
                            if (rows == 0 || cols == 4) {
                                $(SubCatDivChkbox).append($(table).append($('<tr></tr>').append($('<td style="width:25%;"></td>').append("<input type='checkbox' id='" + SubCategoryData[i].SubCategoryID + "' value='" + SubCategoryData[i].SubCategoryID + "'/>").append($('<label>').attr({ for: SubCategoryData[i].SubCategoryID }).text(SubCategoryData[i].Name)))));
                            }else{
                                ($("#tbodyid").find('tr:last').append($('<td style="width:25%;"></td>').append("<input type='checkbox' ' id='" + SubCategoryData[i].SubCategoryID + "' value='" + SubCategoryData[i].SubCategoryID + "'/>").append($('<label>').attr({ for: SubCategoryData[i].SubCategoryID }).text(SubCategoryData[i].Name))));
                            }
                        }
                        if ($('#ddlCategory').val()=='7')
                            $('.divmodality').removeClass('hidden');
                        else
                            $('.divmodality').addClass('hidden');
                    }

                    $(SubCatDivChkbox).find("input[type='checkbox']").click(function (i) {  
                        addText(i.target);
                    });
                },
                error: function (xhr, status) {
                    $(".checkboxlist-subcategory").prop("disabled", false);
                }
            });
        }

        var bindModality = function (subcategoryid, CentreID) {
            $ddlModality = $('#ddlModality');
            if (typeof subcategoryid === undefined) subcategoryid = '0';
            serverCall('../common/CommonService.asmx/BindModality', { SubcategoryID: subcategoryid, CentreID: CentreID }, function (response) {
                var responseData = JSON.parse(response);
                $ddlModality.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: false });

            });
        }

        function GetCategoryName(catID) {
            var Cname = "";
            $.ajax({
                url: "TokenGenerationMaster.aspx/GetCategoryName",
                data: '{CategoryID:"' + catID + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                async: false,
                dataType: "json",
            }).done(function (res) {
                Cname = JSON.parse(res.d);
            });
            return Cname;
        }

        function GetGroupName(grupID) {
            var Gname = "";
            $.ajax({
                url: "TokenGenerationMaster.aspx/GetGroupName",
                data: '{GroupID:"' + grupID + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                async: false,
                dataType: "json",
            }).done(function (res) {
                Gname = JSON.parse(res.d);
            });
            return Gname;
        }

        function GetSubCategoryName(SubcatID) {
            var SubCat = "";
            $.ajax({
                url: "TokenGenerationMaster.aspx/GetSubCategoryName",
                data: '{SubCategoryID:"' + SubcatID + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                async: false,
                dataType: "json",
            }).done(function (res) {
                SubCat = JSON.parse(res.d);
            });
            return SubCat;
        }

        function CheckActive(groupid) {
            var isActive = "";
            $.ajax({
                url: "TokenGenerationMaster.aspx/IsActive",
                data: '{GroupID:"' + groupid + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                async: false,
                dataType: "json",
            }).done(function (res) {
                isActive = JSON.parse(res.d);
            });
            return isActive;
        }

        function editGroup(rowid,id) {
            //var id = $(this).attr("itemID");
            if ($("#rbDactive_" + id).prop("checked")) {
                var groupname = $(rowid).closest('tr').find('#tdGroupID').text().trim();
                $.ajax({
                    url: "TokenGenerationMaster.aspx/EditGroup",
                    data: '{GroupName:"' + groupname + '" }',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    async: false,
                    dataType: "json",
                }).done(function (res) {
                    $("#tb_grdGroup").find('tr').each(function (i) {
                        if (i != 0) {
                            var $fieldset = $(this);
                            var valuee = $('input:hidden:eq(0)', $fieldset).val();
                            if (valuee == groupname) {
                                $("#" + i).hide();
                            }
                        }
                    });
                });
            }
            else { modelAlert("Select Radio button for edit");}
        }

        var changeOnCentre = function (centreID) {
            var subcategoryid = 0;
            subcategoryid = $('.checkboxlist-subcategory table tbody tr input[type=checkbox]:checked').length > 0 ? $('.checkboxlist-subcategory table tbody tr input[type=checkbox]:checked').val() : 0;
            bindModality(subcategoryid, centreID, function () { });
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Token Generation Master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
                <input id="rdoCat" type="radio" name="Con" value="Cat" checked="checked" />Category Wise
		        <input id="rdoSubCat" type="radio" name="Con" value="SubCat" />Sub Category Wise
            </div>

        </div>
        <div class="POuter_Box_Inventory">
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCentre" class="requiredField" onchange="changeOnCentre($(this).val());"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCategory" tabindex="1" title="Select Category"></select>
                        </div>
                       
                       <div class="col-md-3">
                            Reset Time
							<b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input id="rdoDay" type="radio" name="reset" value="Day" checked="checked" />Day
		                    <input id="rdoMonth" type="radio" name="reset" value="Month" />Month   
                            <input id="rdoYear" type="radio" name="reset" value="Year" />Year
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
             <div class="row" id="divSubCat">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sub Category
                            </label>
                            <b class="pull-right">:</b>
                                </div>
                        <div class ="col-md-21 checkboxlist-subcategory" >

                        </div>
                    </div>
                 </div>
                 </div>
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Group Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtGroupName" maxlength="100" title="Enter Group Name" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                           <label class="pull-left">
                             Token Prefix
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="text-align: center center">
                             <input type="text" id="txtSequenceNo" maxlength="100" title="Enter Squence Name"  class="requiredField" />
                        </div>
                        <div class="col-md-3 divmodality  hidden">
                        <label class="pull-left">
                             Modality Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 divmodality hidden">
                             <select id="ddlModality" title="Select modality" class="requiredField" ></select>
                        </div>
                    </div>
                </div>
            </div>
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-24" style="text-align:center;">
                                <input type="button" onclick="BindGrid();" value="Add" id="btnAdd" />
                        </div>
                        </div>
                    </div>
                  <div class="col-md-1"></div>
                 </div>
        </div>
        <div class="POuter_Box_Inventory">
                <table class="GridViewStyle" rules="all" border="1" id="tb_grdLabSearch"
                    style="width: 100%; border-collapse: collapse; display: none;">
                    <tr id="Header">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.
                        </th>
                     
                        <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Token Type
                        </th>
                         <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Category Name
                        </th>
                         <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">SubCategory Name
                        </th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Modality Name
                        </th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Group Name
                        </th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Token Prefix
                        </th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Reset Type
                        </th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Delete
                        </th>
                    </tr>
                </table>
            </div>
        <div style="text-align: center" class="POuter_Box_Inventory">
                <input type="button" id="btnSave" value="Save" tabindex="5" style="margin-top: 7px" class="ItDoseButton save" />
        </div>
        <div class="POuter_Box_Inventory">
             <div id="groupOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
        </div>
    </div>
    <script id="tb_SearchCategoryDetail" type="text/html">
            <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdGroup" style="width:100%;border-collapse:collapse;">
                <tr id="Tr1">
			        <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Centre Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Token Type</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Category Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Sub-Category Name</th>	
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Modality Name</th>	
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">GroupName</th>		          
                    <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Token Prefix</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Reset Type</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">D-Active</th>  
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Edit</th>       
		        </tr>
                <#
                     var dataLength=CategoryDetail.length;
                     var objRow;
                     var cat;
                    var group;
                    var subcat;
                   var chkActive;
                    for(var j=0;j<dataLength;j++)
                    {
                        objRow = CategoryDetail[j];
                      cat = GetCategoryName(objRow.CategoryID);
                        group=GetGroupName(objRow.GroupID);
                        subcat=GetSubCategoryName(objRow.SubCategoryID);
                        chkActive=CheckActive(objRow.GroupID);
                #>
                        <#if(chkActive==1){#>
                        <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="td1"  style="width:150px;text-align:center" ><#=objRow.CentreName#></td>
                    <td class="GridViewLabItemStyle" id="tdGroupCode"  style="width:150px;text-align:center" ><#=objRow.Token_Type#></td>
                    <td class="GridViewLabItemStyle" id="tdGroupName"  style="width:200px;text-align:center" ><#=cat#>
                    </td>
                    <td class="GridViewLabItemStyle" id="tdIsActive"  style="width:200px;text-align:center" ><#=subcat#></td>
                    <td class="GridViewLabItemStyle" id="tdModalityName"  style="width:200px;text-align:center" ><#=objRow.ModalityName#></td>
                    <td class="GridViewLabItemStyle" id="tdModalityID"  style="width:200px;text-align:center; display:none" ><#=objRow.ModalityID#></td>
                    <td class="GridViewLabItemStyle" id="tdGroupID" style="width:200px;text-align:center"><#=group#>
                        <input type="hidden" class="hf" value='<#=group#>' />
                    </td>
                    <td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><#=objRow.Sequence#></td>
                    <td class="GridViewLabItemStyle" style="width:100px; text-align:center;"><#=objRow.ResetType#></td> 
                    <td class="GridViewLabItemStyle" style="width:60px; text-align:center;">
                        <input type="radio" id="rbDactive_<#=j+1#>" name="rbActiv" /> 
                    </td>  
                    <td class="GridViewLabItemStyle" style="width:60px; text-align:center;"> 
                        <input type="button" value="Edit"   id="btnEdit" itemID="<#=j+1#>"  class="ItDoseButton" onclick="editGroup(this,'<#=j+1#>');" />                       
                    </td>           
                    </tr>
                        <#}#> 
                <#}        
                #> 
                      
            </table>
        </script>
        <script type="text/javascript">

           

            if ($("#rdoCat").is(':checked')) {
                $('#divSubCat').hide();
            }
            $("#rdoCat").bind("click", function () {
                $('#divSubCat').hide();
                $("#txtGroupName").val('');
            });

            $("#rdoSubCat").bind("click", function () {
                $("#txtGroupName").val('');
                $('#divSubCat').hide();
                getCategory();

            });
     
            function CheckAllSelectors(CatID) {
                var status = true;
                $("#tb_grdLabSearch tr").each(function (i, e) {
                    if ($(this).attr("CatID") == 'tr_' + CatID && $(this).attr("ItemSymbol") == 'Cat') {
                        status = false;
                        modelAlert("category already exists");
                        return false;
                    }
                });
                return status;
            }
            function validSubCategoryId(id) {
                var status = true;
                $("#tb_grdLabSearch tr").each(function (i, e) {
                    if ($(this).attr("id") == 'tr_' + id) {
                        status = false;
                        
                        return false;
                    }
                });
                return status;
            }
            function validGroupNameintable(name) {
                var status = true;
                $("#tb_grdLabSearch tr").each(function (i, e) {
                    if($(this).attr('id')!='Header'){
                            if ($(this).find("#td_GroupName").text() == name) {

                                status = false;

                                return false;
                            }
                    }
                });
                return status;
            }
          
            function validCategoryId(CatID) {
                var status = true;
                $("#tb_grdLabSearch tr").each(function (i, e) {
                    if ($(this).attr("CatID") == 'tr_' + CatID) {
                        status = false;
                        modelAlert("category already exists");
                        return false;
                    }
                });
                return status;
            }

            function DeleteRow(rowid) {
                var row = rowid;
                $(row).closest('tr').remove();
                if ($("#tb_grdLabSearch tr").length == "1") {
                    $("#tb_grdLabSearch").hide();

                }
            }

            function CheckGroupExists(groupname) {
                var data = "";
                var CentreID = $('#ddlCentre').val();
                $.ajax({
                    url: "TokenGenerationMaster.aspx/isGroupNameExists",
                    data: '{groupName:"' + groupname + '",CentreID:"' + CentreID + '" }',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    async: false,
                    dataType: "json",
                }).done(function (res) {
                     data = JSON.parse(res.d);
                });
                return data;
            }

            // check in database
            function checkTokenPrefixExist(prefix) {
                var data = "";
                var CentreID = $('#ddlCentre').val();
                $.ajax({
                    url: "TokenGenerationMaster.aspx/checkTokenPrefixExist",
                    data: '{Prefix:"' + prefix + '",CentreID:"' + CentreID + '"  }',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    async: false,
                    dataType: "json",
                }).done(function (res) {
                    data = JSON.parse(res.d);
                });
                return data;
            }

            // check in table
            function checkTokenPrefixAdded(prefix) {
                var status = true;
                $("#tb_grdLabSearch tr").each(function (i, e) {
                    if ($(this).attr('id') != 'Header') {
                        if ($(this).find("#td_Sequence").text() == prefix) {

                            status = false;

                            return false;
                        }
                    }
                });
                return status;
            }

            function BindGrid() {
                var TokenType = "";
                var ResetType = "";
                var CentreID = $('#ddlCentre').val();
                var CategoryID = $('#ddlCategory option:selected').val();
                var CategoryName = $('#ddlCategory option:selected').text();
                var SequenceNo = $('#txtSequenceNo').val().trim();
                var GroupName = $('#txtGroupName').val().trim();
                if (GroupName == '') {
                    modelAlert('Please Enter Group Name');
                    $('#txtGroupName').focus();
                    return false;
                }
                var isGroupexists = CheckGroupExists(GroupName);
                var ModalityID = $('#ddlModality option:selected').val();
                var ModalityName = $('#ddlModality option:selected').text();
                if (SequenceNo == '') {
                    modelAlert('Please Enter Prefix');
                    $('#txtSequenceNo').focus();
                    return false;
                }
                var isPrefixAdded = checkTokenPrefixAdded(SequenceNo);
                if (!isPrefixAdded){
                    modelAlert('Token Prefix Already Added');
                    return false;
                }
                var isPrefixExistinDatabase = checkTokenPrefixExist(SequenceNo);
                // alert(isGroupexists);
                if (validGroupNameintable(GroupName)) {
                    if (isGroupexists != "Exists") {
                        if (isPrefixExistinDatabase != "Exixts") {
                            if (CategoryID == "0") {
                                modelAlert('Please Select Category !!');
                                return false;
                            }

                            if ($("#rdoCat").is(':checked')) {
                                TokenType = "Category";
                            }
                            else if ($("#rdoSubCat").is(':checked')) {
                                TokenType = "SubCategory";
                            }

                            if ($("#rdoDay").is(':checked')) {
                                ResetType = "Day";
                            }
                            else if ($("#rdoMonth").is(':checked')) {
                                ResetType = "Month";
                            }
                            else {
                                ResetType = "Year";
                            }
                            if (TokenType == "SubCategory") {
                                if (ModalityID == '' || ModalityID == 0) {
                                    modelAlert('Please Select Modality  !!');
                                    return false;
                                }
                                if (CheckAllSelectors(CategoryID)) {
                                    $(".checkboxlist-subcategory input:checked").each(function (i, e) {

                                        if (validSubCategoryId(ModalityID)) {
                                            if (validateModalityExists(ModalityID, CategoryID)) {
                                                var SubCategoryid = $(this).attr("id");
                                                var SubCategoryName = $(this).next().text();
                                                var newRow = $('<tr />').attr('id', 'tr_' + ModalityID);
                                                newRow.html('<td class="GridViewLabItemStyle" style="text-align:center;" >' + $("#tb_grdLabSearch tr").length +
                                                     '</td><td class="GridViewLabItemStyle" style="text-align:center;" id=td_TokenType >' + TokenType +
                                                     '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_CategoryID >' + CategoryID +
                                                     '</td><td class="GridViewLabItemStyle" style="text-align:center" id=td_CategoryName >' + CategoryName +

                                                     '</td><td  class="GridViewLabItemStyle" style="text-align:center; display:none;"  id=td_SubCategoryID >' + SubCategoryid +
                                                     '</td><td  class="GridViewLabItemStyle" style="text-align:center;" id=td_SubCategoryName >' + SubCategoryName +
                                                    '</td><td class="GridViewLabItemStyle" style="text-align:center;  display:none;" id=td_ModalityID >' + ModalityID +
                                                    '</td><td class="GridViewLabItemStyle" style="text-align:center" id=td_ModalityName >' + ModalityName +
                                                     '</td><td class="GridViewLabItemStyle"  style="text-align:center;" id=td_GroupName >' + GroupName +
                                                     '</td><td  class="GridViewLabItemStyle" style="text-align:center;" id=td_Sequence >' + SequenceNo +
                                                     '</td><td class="GridViewLabItemStyle"  style="text-align:center;" id=td_ResetType >' + ResetType +
                                                     '</td><td class="GridViewLabItemStyle"  style="text-align:center; display:none;" id=td_CentreID >' + CentreID +
                                                     '</td><td class="GridViewLabItemStyle"  style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);" title="Click To Remove" /></td>'
                                                    );
                                                $("#tb_grdLabSearch").append(newRow);
                                                $('#tr_' + SubCategoryid).attr('CatID', 'tr_' + CategoryID);
                                                $('#tr_' + SubCategoryid).attr('ItemSymbol', 'Sub');
                                                $("#tb_grdLabSearch").show();
                                                $(".checkboxlist-subcategory input").removeAttr("checked");
                                                $("#txtGroupName").val("");
                                                $("#btnSave").removeAttr("disabled");
                                            }
                                            else {
                                                modelAlert('Modality Already Exists');
                                            }
                                        }
                                        else {
                                            modelAlert('Modality Already Added');
                                        }
                                    });
                                }
                            }
                            else if (TokenType == "Category") {
                                if (validCategoryId(CategoryID)) {

                                    var SubCategoryid = $(this).attr("id");
                                    var SubCategoryName = $(this).next().text();
                                    var newRow = $('<tr />').attr('id', 'tr_' + CategoryID);
                                    newRow.html('<td class="GridViewLabItemStyle" style="text-align:center;" >' + $("#tb_grdLabSearch tr").length +
                                         '</td><td class="GridViewLabItemStyle" style="text-align:center;" id=td_TokenType >' + TokenType +
                                         '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_CategoryID >' + CategoryID +
                                         '</td><td class="GridViewLabItemStyle" style="text-align:center" id=td_CategoryName >' + CategoryName +
                                         '</td><td  class="GridViewLabItemStyle" style="text-align:center; display:none;"  id=td_SubCategoryID >' + SubCategoryid +
                                         '</td><td  class="GridViewLabItemStyle" style="text-align:center;" id=td_SubCategoryName >' + SubCategoryName +
                                         '</td><td class="GridViewLabItemStyle" style="text-align:center;  display:none;" id=td_ModalityID >' + 0 +
                                         '</td><td class="GridViewLabItemStyle" style="text-align:center" id=td_ModalityName >' +
                                         '</td><td class="GridViewLabItemStyle"  style="text-align:center;" id=td_GroupName >' + GroupName +
                                         '</td><td  class="GridViewLabItemStyle" style="text-align:center;" id=td_Sequence >' + SequenceNo +
                                         '</td><td class="GridViewLabItemStyle"  style="text-align:center;" id=td_ResetType >' + ResetType +
                                         '</td><td class="GridViewLabItemStyle"  style="text-align:center; display:none;" id=td_CentreID >' + CentreID +
                                         '</td><td class="GridViewLabItemStyle"  style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);" title="Click To Remove" /></td>'
                                        );
                                    $("#tb_grdLabSearch").append(newRow);
                                    $('#tr_' + CategoryID).attr('CatID', 'tr_' + CategoryID);
                                    $('#tr_' + CategoryID).attr('ItemSymbol', 'Cat');
                                    $("#tb_grdLabSearch").show();
                                    $("#txtGroupName").val("");
                                    $("#btnSave").removeAttr("disabled");
                                }
                            }
                        }
                        else { modelAlert("Token Prefix already exists"); }
                    }
                    else { modelAlert("Group Name already exists"); }
                }
                else
                    modelAlert('Group Name Already Added');
            }

            $(function () {
                $("#btnSave").bind("click", function () {
                    var dataToken = new Array();
                    var objdataTokenDt=new Object();
                    $("#tb_grdLabSearch tr").each(function () {
                        var id = $(this).attr("id");
                        var $rowid = $(this).closest("tr");
                        if (id != "Header") {
                            //objdataTokenDt.CategoryID = $.trim($rowid.find("td_CategoryID").text());
                            //dataToken.push(objdataTokenDt);
                            //objdataTokenDt = new Object();
                            var CatID = $(this).find("#td_CategoryID").html();
                            var tokentype = $(this).find("#td_TokenType").html();
                            var subcatID = $(this).find("#td_SubCategoryID").html();
                            var grupName = $(this).find("#td_GroupName").html();
                            var sequnc = $(this).find("#td_Sequence").html();
                            var reset = $(this).find("#td_ResetType").html();
                            var modalityName = $(this).find('#td_ModalityName').html();
                            var modalityID = $(this).find('#td_ModalityID').html();
                            var CentreID = $(this).find('#td_CentreID').html();
                            $.ajax({
                                url: 'TokenGenerationMaster.aspx/SaveTokenmasterDetail',
                                data: '{tokentype:"' + tokentype + '",catId:"' + CatID + '",subcatid:"' + subcatID + '",seq:"' + sequnc + '",resettype:"' + reset + '",groupname:"' + grupName + '",modalityName:"' + modalityName + '",modalityID:"' + modalityID + '",CentreID:"' + CentreID + '"}',
                                dataType: "json",
                                contentType: "application/json;charset=UTF-8",
                                async: false,
                                type: "POST",
                            }).done(function (r) {
                                var url = "TokenGenerationMaster.aspx";
                            });
                        }
                    });
                    
                    $("#tb_grdLabSearch td").html("");
                    $("#tb_grdLabSearch").hide();
                    $("#btnSave").attr("disabled", true);
                    $("#btnAdd").attr("disabled", true);
                    $('#divSubCat').hide();
                    $("#txtGroupName").val('');
                    getCategory();
                    $("#txtSequenceNo").val('');
                    modelAlert("Saved Successfully");
                });
            });

            
            var validateModalityExists = function (modalityID, CategoryID) {
                var status = true;
                if (CategoryID == '7') {
                    var data = "";
                    $.ajax({
                        url: "TokenGenerationMaster.aspx/CheckModalityExists",
                        data: '{modalityID:"' + modalityID + '" }',
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        async: false,
                        dataType: "json",
                    }).done(function (res) {
                        data = JSON.parse(res.d);
                        if (data == '0')
                            status = true;
                        else
                            status = false;
                    });
                }
                return status;


            }
        </script>
</asp:Content>

