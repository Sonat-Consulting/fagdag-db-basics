create table game_state (state int);

create or replace procedure usp_Battle1()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE '---------- Step 1 -----------' ;
        RAISE NOTICE '-- Unwanted null values -----';
        RAISE NOTICE 'Future-Christian: Hello!';
        RAISE NOTICE 'Future-Christian: I am trying to add a new person to the person table.';
        RAISE NOTICE 'I do not know his last name.  I assume it doesnt matter.';
        RAISE NOTICE ' ';
        RAISE NOTICE 'Narrator: It does.';

        BEGIN
            INSERT INTO person values(3250003, 123456789101112, 4000, 'F',   'Martin',  Null);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Future-Christian: Hmmm.. That did not work.';
                RAISE NOTICE 'Narrator: Future-Christian fails to fill the database with nameless people.  Step completed.';
                INSERT INTO game_state values (1);
                RETURN;
         END;

        RAISE NOTICE 'Narrator: Future-Christian succeeds in filling the database with nameless people.   Try to stop him.';
        ROLLBACK;

    end$$;


create or replace procedure usp_Battle2()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE '---------- Step 2 -----------' ;
        RAISE NOTICE '-- Missing foreign key  -----';

        RAISE NOTICE 'Future-Christian: I was thinking to add my city, "Slopergrad". ';
        RAISE NOTICE 'Future-Christian: I do not have a country code for it, so I will add XXX for that';
        RAISE NOTICE ' ';
        RAISE NOTICE 'Narrator:  This is problematic.  We have reports that depend on joining city and country.';

        BEGIN
            INSERT INTO city values (9999,'Slopergrad','XXX','District9',1);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Future-Christian: Uff.. That was not possible either.';
                RAISE NOTICE 'Narrator: Future-Christian must now find country codes to add his cities. The base remains consistent.';
                RAISE NOTICE 'Step completed.';
                INSERT INTO game_state values (2);
                RETURN;
        END;

        RAISE NOTICE 'Narrator: Future-Christian succeeds adding cities with no countries.';
        RAISE NOTICE 'This is problematic when we compare population/country vs. total population.';
        RAISE NOTICE 'Try to add a requirement that all cities has to be in a country.';
        ROLLBACK;


    end$$;



create or replace procedure usp_Battle3()
LANGUAGE plpgsql
AS $$
    BEGIN

        RAISE NOTICE '---------Step 3----------------';
        RAISE NOTICE '--- Duplicate logical key -----';
        RAISE NOTICE 'Future-Christian: I am adding a new password.  I am not sure i remember his world_sec_nr. Maybe i made a mistake here.';
        RAISE NOTICE ' ';
        RAISE NOTICE 'Narrator: If he uses the world_sec_nr of an existing person we will have big problems when the back-end queries us!';
        BEGIN
            INSERT INTO person values(3250001, 8983027730798, 4000, 'M',   'Martin',  'Sloper');
            RAISE NOTICE 'Narrator: Future-Christian adds a new user, but he uses an existing world_sec_nr. This should have been a logical key. Nrgh!';
        EXCEPTION
                WHEN OTHERS THEN
                    RAISE NOTICE 'Future-Christian: Ack... That did not work either.';
                    RAISE NOTICE ' ';
                    RAISE NOTICE 'Narrator: Future-Christian has been stopped and we can still answer the backend when it queries us.';
                    RAISE NOTICE 'Step completed.';
                    INSERT INTO game_state values (3);
                RETURN;
        END;
        RAISE NOTICE 'Narrator:  Future-Christian succeeds.  We can no longer uniquely identify a person when the back end queries us.  We are in deep dodo.';
        RAISE NOTICE 'Narrator:  Do something!';

        ROLLBACK;
    end$$;


create or replace procedure usp_Battle4()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE 'Not implemented';
        INSERT INTO game_state values (4);

    end$$;

create or replace procedure usp_Battle()
LANGUAGE plpgsql
AS $$
    DECLARE
        state integer;
    BEGIN
        state := (select coalesce(max(game_state.state),0) from game_state);

        CASE state
            when 0 THEN call usp_Battle1(); -- missing not null
            when 1 THEN call usp_Battle2(); -- missing foreign key
            when 2 THEN call usp_Battle3(); -- inserting logical duplicate
            when 3 THEN call usp_Battle4(); -- constraint value
            else
                RAISE Notice 'You have completed the game.  You have cleaned up after Past-Christian and have stopped Future-Christian (for now). ';
                RAISE Notice 'The base is now a safer place.';
                RAISE Notice 'Congratulations!';
        end case;

    end$$;